
# 특정 Target Group과 연결된 EC2 인스턴스 가져오기
data "aws_instances" "fastapi_instances" {
  provider = aws.seoul
  filter {
    name   = "tag:eks:cluster-name"
    values = ["CV_seoul_cluster"]  # ✅ Target Group과 연결된 서비스 이름
  }
}

# output "fastapi_instance_ids" {
#   value = data.aws_instances.fastapi_instances.ids
# }

# output "fastapi_instance_private_ips" {
#   value = data.aws_instances.fastapi_instances.private_ips
# }

resource "aws_prometheus_workspace" "prometheus" {
  provider    = aws.seoul
  alias = "boyage-prometheus"
}

resource "aws_instance" "prometheus_server" {
  provider    = aws.seoul
  ami         = "ami-0cee4e6a7532bb297"
  instance_type = "t2.small"
  key_name      = "boyage"
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]
  iam_instance_profile = aws_iam_instance_profile.prometheus_instance_profile.name
  subnet_id   = aws_subnet.CV_public_seoul_a.id

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y wget tar firewalld

    # 방화벽 설정
    systemctl start firewalld 
    systemctl enable firewalld
    firewall-cmd --add-port=9090/tcp --permanent
    firewall-cmd --add-port=31028/tcp --permanent
    firewall-cmd --add-port=9100/tcp --permanent
    firewall-cmd --reload

    cd /opt
    wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz
    tar -xzf prometheus-2.37.0.linux-amd64.tar.gz
    mv prometheus-2.37.0.linux-amd64 prometheus

    cat <<EOT > /opt/prometheus/prometheus.yml
    scrape_configs:
      - job_name: 'fastapi-exporter'
        static_configs:
          - targets: ['fastapi-service.eks-apiservice.svc.cluster.local:80']
  
    EOT

    nohup /opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml --web.listen-address="0.0.0.0:9090" &
  EOF

  tags = {
    Name = "Prometheus-Server"
  }
} 


# resource "aws_instance" "prometheus_server" {
#   provider    = aws.seoul
#   ami         = "ami-0cee4e6a7532bb297"  # Amazon Linux 2 AMI
#   instance_type = "t2.medium"
#   key_name      = "boyage"  # 기존 키페어 사용
#   vpc_security_group_ids = [aws_security_group.prometheus_sg.id]
#   iam_instance_profile = aws_iam_instance_profile.prometheus_instance_profile.name
#   subnet_id   = aws_subnet.CV_public_seoul_a.id

#   user_data = <<-EOF
#     #!/bin/bash
#     set -eux

#     exec > /var/log/user-data.log 2>&1

#     sudo yum update -y
#     sudo yum install -y wget tar firewalld

#     sudo systemctl start firewalld
#     sudo systemctl enable firewalld
#     sudo firewall-cmd --add-port=9090/tcp --permanent
#     sudo firewall-cmd --reload

#     sudo chmod 777 /opt

#     cd /opt
#     sudo wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz
#     sudo tar -xzf prometheus-2.37.0.linux-amd64.tar.gz
#     sudo mv prometheus-2.37.0.linux-amd64 prometheus

#     sudo chmod -R 755 /opt/prometheus
#     sudo chmod +x /opt/prometheus/prometheus

#     PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
#     PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

#     sudo bash -c 'cat <<EOT > /opt/prometheus/prometheus.yml
#     global:
#       scrape_interval: 15s

#  scrape_configs:
#       - job_name: "prometheus_server"
#         static_configs:
#           - targets: ["'"$PUBLIC_IP"':9090"]
#             labels:
#               instance: "prometheus_server"

#       - job_name: "prometheus_self"
#         static_configs:
#           - targets: ["'"$PRIVATE_IP"':9100"]
#             labels:
#               instance: "prometheus_self"

#       - job_name: "node-exporter"
#         ec2_sd_configs:
#           - region: ap-northeast-2
#             port: 9100
#         relabel_configs:
#           - source_labels: [__meta_ec2_private_ip]
#             target_label: instance
#     EOT'


#     sudo bash -c 'cat <<EOT > /etc/systemd/system/prometheus.service
#     [Unit]
#     Description=Prometheus
#     After=network.target

#     [Service]
#     User=root
#     ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml --web.listen-address=0.0.0.0:9090
#     Restart=always

#     [Install]
#     WantedBy=multi-user.target
#     EOT'

#     sudo systemctl daemon-reload
#     sudo systemctl enable prometheus
#     sudo systemctl start prometheus
#   EOF

#   tags = {
#     Name = "Prometheus-Server"
#   }
# }



resource "aws_iam_role" "prometheus_role" {
  name = "Prometheus_Monitoring_Role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "prometheus_policy" {
  name        = "prometheus_policy"
  description = "Policy for Prometheus Ec2"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow",
      Action   = ["ec2:DescribeInstances", "ec2:DescribeTags"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "prometheus_attachment" {
  role       = aws_iam_role.prometheus_role.name
  policy_arn = aws_iam_policy.prometheus_policy.arn
}

resource "aws_iam_instance_profile" "prometheus_instance_profile" {
  name = "prometheus-instance-profile"
  role = aws_iam_role.prometheus_role.name
}
