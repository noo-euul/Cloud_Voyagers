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

# 프랑스 라우팅 테이블
resource "aws_route_table" "public_rt_france" {
  provider = aws.france
  vpc_id   = aws_vpc.france.id
  tags = {
    Name = "CV_Public_RT_France"
  }
}

resource "aws_route" "public_route_france" {
  provider              = aws.france
  route_table_id         = aws_route_table.public_rt_france.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_france.id
}

resource "aws_route_table_association" "public_rt_assoc_france" {
  provider       = aws.france
  subnet_id      = aws_subnet.public_france.id
  route_table_id = aws_route_table.public_rt_france.id
}
