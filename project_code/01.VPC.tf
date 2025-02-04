# 서울 리전 VPC 생성
provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"
}

resource "aws_vpc" "seoul" {
  provider             = aws.seoul
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_seoul"
  }
}

# 미국 버지니아 리전 VPC 생성
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_vpc" "virginia" {
  provider             = aws.virginia
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_virginia"
  }
}
