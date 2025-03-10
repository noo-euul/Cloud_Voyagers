
resource "aws_security_group" "lambda_sg" {
  provider    = aws.seoul
  vpc_id      = aws_vpc.CV_seoul_vpc.id
  
  name        = "lambda_sg"
  tags = { Name = "lambda_sg" }
  description = "Lambda Security Group"

  # ✅ Lambda에서 나가는 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lambda_sg_us" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  name        = "lambda_sg"
  tags = { Name = "lambda_sg" }
  description = "Lambda Security Group"

  # ✅ Lambda에서 나가는 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################
##################################################################

resource "aws_security_group" "eks_sg" {
  provider    = aws.seoul
  vpc_id      = aws_vpc.CV_seoul_vpc.id
  
  name        = "eks_sg"
  tags = { Name = "eks_sg" }
  description = "EKS Security Group"

  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg.id]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 31028
    to_port     = 31028
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_sg_us" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  
  name        = "eks_sg"
  tags = { Name = "eks_sg" }
  description = "EKS Security Group"

  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    security_groups = [aws_security_group.lambda_sg_us.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg_us.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg_us.id]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lambda_sg_us.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################
##################################################################

resource "aws_security_group" "proxy_sg" {
  provider    = aws.seoul
  vpc_id      = aws_vpc.CV_seoul_vpc.id
  
  name        = "proxy_sg"
  tags = { Name = "proxy_sg" }
  description = "Proxy Security Group"
 
  ingress {
    from_port   = -1  # ✅ ICMP 전체 허용
    to_port     = -1  # ✅ ICMP 전체 허용
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ 모든 네트워크에서 ICMP 허용 (보안 설정 필요)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg.id , aws_default_security_group.default_sg_ko.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg.id, aws_default_security_group.default_sg_ko.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg.id, aws_default_security_group.default_sg_ko.id]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "proxy_sg_us" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
 
  name        = "proxy_sg"
  tags = { Name = "proxy_sg" }
  description = "Proxy Security Group"
  
   ingress {
    from_port   = -1  # ✅ ICMP 전체 허용
    to_port     = -1  # ✅ ICMP 전체 허용
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ 모든 네트워크에서 ICMP 허용 (보안 설정 필요)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg_us.id, aws_default_security_group.default_sg_us.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg_us.id, aws_default_security_group.default_sg_us.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.eks_sg_us.id, aws_default_security_group.default_sg_us.id]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################
##################################################################

resource "aws_security_group" "aurora_sg" {
  provider    = aws.seoul
  vpc_id      = aws_vpc.CV_seoul_vpc.id
  
  name        = "aurora_sg"
  tags = { Name = "aurora_sg" }
  description = "AuroraDB Security Group"
  
  ingress {
    from_port   = -1  # ✅ ICMP 전체 허용
    to_port     = -1  # ✅ ICMP 전체 허용
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ 모든 네트워크에서 ICMP 허용 (보안 설정 필요)
    security_groups = [
      aws_security_group.proxy_sg.id,
      aws_security_group.eks_sg.id
      ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg.id,
      aws_security_group.eks_sg.id
      ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg.id,
      aws_security_group.eks_sg.id
      ]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg.id,
      aws_security_group.eks_sg.id
      ]
  }

   ingress {
    from_port   = 33060
    to_port     = 33060
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg.id,
      aws_security_group.eks_sg.id
      ]
  }

  # ✅ RDS에서 나가는 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aurora_sg_us" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  name        = "aurora_sg"
  tags = { Name = "aurora_sg" }
  description = "AuroraDB Security Group"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg_us.id,
      aws_security_group.eks_sg_us.id
      ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg_us.id,
      aws_security_group.eks_sg_us.id
      ]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg_us.id,
      aws_security_group.eks_sg_us.id
      ]
  }

   ingress {
    from_port   = 33060
    to_port     = 33060
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [
      aws_security_group.proxy_sg_us.id,
      aws_security_group.eks_sg_us.id
      ]
  }

  # ✅ RDS에서 나가는 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################
##################################################################

resource "aws_security_group" "prometheus_sg" {
  provider    = aws.seoul
  vpc_id      = aws_vpc.CV_seoul_vpc.id
  
  name        = "prometheus_sg"
  tags = { Name = "prometheus_sg" }
  description = "Prometheus Security Group"
  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prometheus_sg_us" {
  provider    = aws.virginia
  vpc_id      = aws_vpc.CV_virginia_vpc.id
  
  name        = "prometheus_sg"
  tags = { Name = "prometheus_sg" }
  description = "Prometheus Security Group"

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
