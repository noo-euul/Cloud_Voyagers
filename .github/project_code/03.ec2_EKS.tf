# =========================================
# 1. EKS 클러스터 생성
# =========================================
resource "aws_eks_cluster" "CV_seoul_cluster" {
  provider = aws.seoul

  name     = "CV-seoul-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.CV_private_seoul_a.id,
      aws_subnet.CV_private_seoul_c.id
    ]
  }
}

resource "aws_eks_cluster" "CV_virginia_cluster" {
  provider = aws.virginia

  name     = "CV-virginia-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.CV_private_virginia_a.id,
      aws_subnet.CV_private_virginia_c.id
    ]
  }
}

# =========================================
# 2. EKS 클러스터 IAM 역할 생성
# =========================================
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# =========================================
# 3. EKS 노드 IAM 역할 생성
# =========================================
resource "aws_iam_role" "eks_node_role" {
  provider = aws.seoul
  name     = "CV-seoul-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "eks_node_role_virginia" {
  provider = aws.virginia
  name     = "CV-virginia-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# =========================================
# 4. IAM 정책 할당
# =========================================
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_seoul" {
  provider   = aws.seoul
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_seoul" {
  provider   = aws.seoul
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_seoul" {
  provider   = aws.seoul
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_virginia" {
  provider   = aws.virginia
  role       = aws_iam_role.eks_node_role_virginia.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_virginia" {
  provider   = aws.virginia
  role       = aws_iam_role.eks_node_role_virginia.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_virginia" {
  provider   = aws.virginia
  role       = aws_iam_role.eks_node_role_virginia.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# =========================================
# 5. EKS 워커 노드 그룹 생성
# =========================================
resource "aws_eks_node_group" "CV_seoul_node_group" {
  provider       = aws.seoul
  cluster_name   = aws_eks_cluster.CV_seoul_cluster.name
  node_group_name = "CV-seoul-node-group"
  node_role_arn  = aws_iam_role.eks_node_role.arn
  subnet_ids     = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]

  remote_access {
    ec2_ssh_key = "CV_seoul_key"
  }
}

resource "aws_eks_node_group" "CV_virginia_node_group" {
  provider       = aws.virginia
  cluster_name   = aws_eks_cluster.CV_virginia_cluster.name
  node_group_name = "CV-virginia-node-group"
  node_role_arn  = aws_iam_role.eks_node_role_virginia.arn
  subnet_ids     = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]

  remote_access {
    ec2_ssh_key = "CV_key_virginia"
  }
}
