provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

resource "aws_vpc" "seoul" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_Seoul"
  }
}

provider "aws" {
  alias  = "france"
  region = "eu-west-3" # 프랑스 리전
}

resource "aws_vpc" "france" {
  provider             = aws.france
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_France"
  }
}
