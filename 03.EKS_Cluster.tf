

data "aws_eks_cluster" "CV_seoul_cluster" {
  provider = aws.seoul
  name = aws_eks_cluster.CV_seoul_cluster.name
  depends_on = [aws_eks_cluster.CV_seoul_cluster]
}

data "aws_eks_cluster_auth" "eks_seoul_cluster_auth" {
  name = aws_eks_cluster.CV_seoul_cluster.id
}

data "aws_security_group" "eks_seoul_cluster_sg" {
  provider = aws.seoul
  id = data.aws_eks_cluster.CV_seoul_cluster.vpc_config[0].cluster_security_group_id
  
  depends_on = [aws_eks_cluster.CV_seoul_cluster]
}

data "aws_eks_cluster" "CV_virginia_cluster" {
  provider = aws.virginia
  name = aws_eks_cluster.CV_virginia_cluster.name
  depends_on = [aws_eks_cluster.CV_virginia_cluster]
}

data "aws_eks_cluster_auth" "eks_virginia_cluster_auth" {
  name = aws_eks_cluster.CV_virginia_cluster.id
}

data "aws_security_group" "eks_virginia_cluster_sg" {
  provider = aws.virginia
  id = data.aws_eks_cluster.CV_virginia_cluster.vpc_config[0].cluster_security_group_id
  
  depends_on = [aws_eks_cluster.CV_virginia_cluster]
}

##################################################################
##################################################################

resource "aws_eks_cluster" "CV_seoul_cluster" {
  provider = aws.seoul
  name     = "CV_seoul_cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids         = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id]
    security_group_ids = [aws_security_group.eks_sg.id]
    endpoint_private_access = true  #  프라이빗 접근 활성화
    endpoint_public_access  = true  #  필요 시 유지 (외부 접근 허용)
  }

  tags = {
    Name        = "CV-seoul-cluster"
    Environment = "Production"
  }

  depends_on = [aws_iam_role.eks_role, aws_security_group.eks_sg]
}

resource "aws_eks_node_group" "CV_seoul_node_group" {
  provider        = aws.seoul
  cluster_name    = aws_eks_cluster.CV_seoul_cluster.name
  node_group_name = "CV_seoul_node_group"
  node_role_arn   = aws_iam_role.eks_rds_role.arn
  version = "1.32"
  instance_types = ["t3.medium"]
  subnet_ids      = [
    aws_subnet.CV_private_seoul_a.id,
    aws_subnet.CV_private_seoul_c.id
    ]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  remote_access {
    ec2_ssh_key = "boyage"
  }

  # ✅ Terraform에서 생성된 모든 EC2에 공통적으로 적용할 태그
  tags = {
    Name        = "EKS-Node-${random_string.node_suffix.result}"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "CloudInfra"
  }

  # ✅ `random_string`이 먼저 실행되도록 설정
  depends_on = [aws_eks_cluster.CV_seoul_cluster, random_string.node_suffix]
}


resource "aws_eks_cluster" "CV_virginia_cluster" {
  provider = aws.virginia
  name     = "CV_virginia_cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids         = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]
    security_group_ids = [aws_security_group.eks_sg_us.id]
    endpoint_private_access = true  # ✅ 프라이빗 접근 활성화
    endpoint_public_access  = true  # ✅ 필요 시 유지 (외부 접근 허용)
  }

  tags = {
    Name        = "CV-virginia-cluster"
    Environment = "Production"
  }

  depends_on = [aws_iam_role.eks_role, aws_security_group.eks_sg_us]
}

resource "aws_eks_node_group" "CV_virginia_node_group" {
  provider        = aws.virginia
  cluster_name    = aws_eks_cluster.CV_virginia_cluster.name
  node_group_name = "CV_virginia_node_group"
  node_role_arn   = aws_iam_role.eks_rds_role.arn
  version = "1.32"
  instance_types = ["t3.medium"]
  subnet_ids      = [
    aws_subnet.CV_private_virginia_a.id,
    aws_subnet.CV_private_virginia_c.id
    ]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  remote_access {
    ec2_ssh_key = "boyage"
  }

  # ✅ Terraform에서 생성된 모든 EC2에 공통적으로 적용할 태그
  tags = {
    Name        = "EKS-Node-${random_string.node_suffix.result}"
    # count = 2
    # Name = "EKS-Node-${count.index}"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "CloudInfra"
  }

  # ✅ `random_string`이 먼저 실행되도록 설정
  depends_on = [aws_eks_cluster.CV_virginia_cluster, random_string.node_suffix]
}

##################################################################
##################################################################

resource "aws_ecr_repository" "fastapi_repo" {
  provider = aws.seoul
  name = "fastapi-app"
  image_scanning_configuration {
    scan_on_push = true  # 새로운 이미지 업로드 시 취약점 스캔 활성화
  }
  tags = {
    Name = "FastAPI-ECR-Repo"
  }

   encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "fastapi_repo_us" {
  provider = aws.virginia
  name = "fastapi-app-ud"
  image_scanning_configuration {
    scan_on_push = true  # 새로운 이미지 업로드 시 취약점 스캔 활성화
  }
  tags = {
    Name = "FastAPI-ECR-Repo"
  }

   encryption_configuration {
    encryption_type = "AES256"
  }
}


resource "aws_iam_policy" "iam_pass_to_EKS_role" {
  name        = "IAM_PassRole_to_EKS_Policy"
  description = "Allow IAM roles to be passed to EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "eks:AssociateRole",
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:ListClusters",
          "iam:PassRole",
          "eks:DescribeNodegroup",
          "eks:CreateNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:DeleteNodegroup"
        ],
        Resource = aws_eks_cluster.CV_seoul_cluster.arn
      }
    ]
  })

  depends_on = [ aws_eks_cluster.CV_seoul_cluster ]
}

resource "aws_iam_role_policy_attachment" "attach_iam_pass_role" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.iam_pass_to_EKS_role.arn
}