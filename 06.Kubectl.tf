
provider "kubernetes" {
  alias = "seoul"
  host                   = data.aws_eks_cluster.CV_seoul_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_seoul_cluster_auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.CV_seoul_cluster.certificate_authority[0].data)
}


provider "kubernetes" {
  alias = "virginia"
  host                   = data.aws_eks_cluster.CV_virginia_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_virginia_cluster_auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.CV_virginia_cluster.certificate_authority[0].data)
}


// cmd창에서 'C:\Project\boyage\docker_build.bat' 실행하여 Docker Image 빌드 및 Docker Container 생성




