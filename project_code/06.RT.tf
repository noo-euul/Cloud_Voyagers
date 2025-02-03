# 서울 라우팅 테이블
resource "aws_route_table" "public_rt_seoul" {
  vpc_id = aws_vpc.seoul.id
  tags = {
    Name = "CV_Public_RT_Seoul"
  }
}

resource "aws_route" "public_route_seoul" {
  route_table_id         = aws_route_table.public_rt_seoul.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_seoul.id
}

resource "aws_route_table_association" "public_rt_assoc_seoul" {
  subnet_id      = aws_subnet.public_seoul.id
  route_table_id = aws_route_table.public_rt_seoul.id
}

# 미국 버지니아 라우팅 테이블
resource "aws_route_table" "public_rt_Virginia" {
  provider = aws.Virginia
  vpc_id   = aws_vpc.Virginia.id
  tags = {
    Name = "CV_Public_RT_Virginia"
  }
}

resource "aws_route" "public_route_Virginia" {
  provider              = aws.Virginia
  route_table_id         = aws_route_table.public_rt_Virginia.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_Virginia.id
}

resource "aws_route_table_association" "public_rt_assoc_Virginia" {
  provider       = aws.Virginia
  subnet_id      = aws_subnet.public_Virginia.id
  route_table_id = aws_route_table.public_rt_Virginia.id
}
