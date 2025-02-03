# 서울 VPC 서브넷
resource "aws_subnet" "public_seoul" {
  vpc_id                  = aws_vpc.seoul.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "CV_Subnet_Public_Seoul"
  }
}

resource "aws_subnet" "private_seoul" {
  vpc_id            = aws_vpc.seoul.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "CV_Subnet_Private_Seoul"
  }
}

# 미국 버지니아 VPC 서브넷
resource "aws_subnet" "public_Virginia" {
  provider               = aws.Virginia
  vpc_id                 = aws_vpc.Virginia.id
  cidr_block             = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone      = "us-east-1a"
  tags = {
    Name = "CV_Subnet_Public_Virginia"
  }
}

resource "aws_subnet" "private_Virginia" {
  provider         = aws.Virginia
  vpc_id           = aws_vpc.Virginia.id
  cidr_block       = "10.1.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "CV_Subnet_Private_Virginia"
  }
}
