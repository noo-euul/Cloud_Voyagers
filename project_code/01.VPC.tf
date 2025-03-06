resource "aws_vpc" "CV_seoul_vpc" {
  provider   = aws.seoul
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CV_seoul_vpc"
  }
}

resource "aws_vpc" "CV_virginia_vpc" {
  provider   = aws.virginia
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "CV_virginia_vpc"
  }
}
