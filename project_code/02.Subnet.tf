# 서울 VPC 서브넷
resource "aws_subnet" "public_seoul" {
  provider               = aws.seoul
  vpc_id                 = aws_vpc.seoul.id
  cidr_block             = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone      = "ap-northeast-2a"
  tags = {
    Name = "CV_Subnet_Public_seoul"
  }
}

resource "aws_subnet" "private_seoul" {
  provider               = aws.seoul
  vpc_id                 = aws_vpc.seoul.id
  cidr_block             = "10.0.2.0/24"
  availability_zone      = "ap-northeast-2b"
  tags = {
    Name = "CV_Subnet_Private_seoul"
  }
}

# 미국 버지니아 VPC 서브넷
resource "aws_subnet" "public_virginia" {
  provider               = aws.virginia
  vpc_id                 = aws_vpc.virginia.id
  cidr_block             = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone      = "us-east-1a"
  tags = {
    Name = "CV_Subnet_Public_virginia"
  }
}

resource "aws_subnet" "private_virginia" {
  provider               = aws.virginia
  vpc_id                 = aws_vpc.virginia.id
  cidr_block             = "10.1.2.0/24"
  availability_zone      = "us-east-1b"
  tags = {
    Name = "CV_Subnet_Private_virginia"
  }
}