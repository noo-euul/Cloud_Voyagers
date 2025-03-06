provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
  alias  = "seoul"
}

provider "aws" {
  region = "us-east-1"  # 버지니아 리전
  alias  = "virginia"
}

resource "aws_vpc" "CV_seoul_vpc" {
  provider   = aws.seoul
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "CV_seoul_vpc"
  }
}

resource "aws_vpc" "CV_virginia_vpc" {
  provider   = aws.virginia
  cidr_block = "10.2.0.0/16"

  tags = {
    Name = "CV_virginia_vpc"
  }
}
