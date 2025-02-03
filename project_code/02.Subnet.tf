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

# 프랑스 VPC 서브넷
resource "aws_subnet" "public_france" {
  provider               = aws.france
  vpc_id                 = aws_vpc.france.id
  cidr_block             = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone      = "eu-west-3a"
  tags = {
    Name = "CV_Subnet_Public_France"
  }
}

resource "aws_subnet" "private_france" {
  provider         = aws.france
  vpc_id           = aws_vpc.france.id
  cidr_block       = "10.1.2.0/24"
  availability_zone = "eu-west-3a"
  tags = {
    Name = "CV_Subnet_Private_France"
  }
}
