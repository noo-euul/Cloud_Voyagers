# 서울 퍼블릭 서브넷
resource "aws_subnet" "CV_public_seoul_a" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_seoul_a"
  }
}

resource "aws_subnet" "CV_public_seoul_c" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_seoul_c"
  }
}

# 서울 프라이빗 서브넷
resource "aws_subnet" "CV_private_seoul_a" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "CV_private_seoul_a"
  }
}

resource "aws_subnet" "CV_private_seoul_c" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "CV_private_seoul_c"
  }
}

# 버지니아 퍼블릭 서브넷
resource "aws_subnet" "CV_public_virginia_a" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.2.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_virginia_a"
  }
}

resource "aws_subnet" "CV_public_virginia_c" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.2.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_virginia_c"
  }
}

# 버지니아 프라이빗 서브넷
resource "aws_subnet" "CV_private_virginia_a" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.2.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "CV_private_virginia_a"
  }
}

resource "aws_subnet" "CV_private_virginia_c" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.2.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "CV_private_virginia_c"
  }
}
