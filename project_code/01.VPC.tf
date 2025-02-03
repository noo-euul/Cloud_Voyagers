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
  alias  = "Virginia"
  region = "us-east-1" # 미국 버지니아 리전
}

resource "aws_vpc" "Virginia" {
  provider             = aws.Virginia
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CV_VPC_Virginia"
  }
}
