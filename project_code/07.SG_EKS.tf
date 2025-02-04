# 서울 리전 보안 그룹
resource "aws_security_group" "seoul_sg" {
  vpc_id = aws_vpc.seoul.id
  name   = "CV_SG_seoul"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # 서울 VPC CIDR
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 IP에서 HTTP 요청 허용
  }
}

# 버지니아 리전 보안 그룹
resource "aws_security_group" "virginia_sg" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id
  name     = "CV_SG_virginia"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]  # 버지니아 VPC CIDR
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 모든 IP에서 HTTP 요청 허용
  }
}

# 서울 리전 EKS 클러스터
resource "aws_eks_cluster" "cv_eks_cluster_seoul" {
  name     = "CV_EKS_Cluster_Seoul"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids        = aws_subnet.seoul_public_subnet.*.id
    security_group_ids = [aws_security_group.seoul_sg.id]  # 서울 리전 보안 그룹 지정
  }

  tags = {
    Name = "CV_EKS_Cluster_Seoul"
  }
}

# 미국 버지니아 리전 EKS 클러스터
resource "aws_eks_cluster" "cv_eks_cluster_virginia" {
  provider = aws.virginia
  name     = "CV_EKS_Cluster_Virginia"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids        = aws_subnet.virginia_public_subnet.*.id
    security_group_ids = [aws_security_group.virginia_sg.id]  # 버지니아 리전 보안 그룹 지정
  }

  tags = {
    Name = "CV_EKS_Cluster_Virginia"
  }
}
