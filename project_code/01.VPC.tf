provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

resource "aws_vpc" "seoul" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_seoul"
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1" # 미국 버지니아 리전
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