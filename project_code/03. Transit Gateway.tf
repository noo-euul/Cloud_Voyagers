# 서울 VPC 퍼블릭 서브넷
resource "aws_subnet" "public_seoul" {
  vpc_id                  = aws_vpc.seoul.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "CV_Subnet_Public_Seoul"
  }
}

# 서울 VPC 프라이빗 서브넷
resource "aws_subnet" "private_seoul" {
  vpc_id            = aws_vpc.seoul.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "CV_Subnet_Private_Seoul"
  }
}

# 서울 VPC Transit Gateway에 퍼블릭과 프라이빗 서브넷 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "seoul_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.cv_transit_gateway.id
  vpc_id = aws_vpc.seoul.id
  subnet_ids = [
    aws_subnet.public_seoul.id,
    aws_subnet.private_seoul.id  # 퍼블릭과 프라이빗 서브넷을 모두 연결
  ]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Seoul"
  }
}
