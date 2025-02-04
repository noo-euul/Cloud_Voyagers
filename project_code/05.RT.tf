# 서울 퍼블릭 라우팅 테이블
resource "aws_route_table" "public_rt_seoul" {
  provider = aws.seoul
  vpc_id   = aws_vpc.seoul.id
  tags = {
    Name = "CV_Public_RT_seoul"
  }
}

resource "aws_route" "public_route_seoul" {
  provider              = aws.seoul
  route_table_id        = aws_route_table.public_rt_seoul.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_seoul.id
}

resource "aws_route_table_association" "public_rt_assoc_seoul" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.public_seoul.id
  route_table_id = aws_route_table.public_rt_seoul.id
}

# 서울 프라이빗 라우팅 테이블
resource "aws_route_table" "private_rt_seoul" {
  provider = aws.seoul
  vpc_id   = aws_vpc.seoul.id
  tags = {
    Name = "CV_Private_RT_seoul"
  }
}

resource "aws_route" "private_route_seoul" {
  provider              = aws.seoul
  route_table_id        = aws_route_table.private_rt_seoul.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_seoul.id
}

resource "aws_route_table_association" "private_rt_assoc_seoul" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.private_seoul.id
  route_table_id = aws_route_table.private_rt_seoul.id
}

# 버지니아 퍼블릭 라우팅 테이블
resource "aws_route_table" "public_rt_virginia" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id
  tags = {
    Name = "CV_Public_RT_virginia"
  }
}

resource "aws_route" "public_route_virginia" {
  provider              = aws.virginia
  route_table_id        = aws_route_table.public_rt_virginia.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_virginia.id
}

resource "aws_route_table_association" "public_rt_assoc_virginia" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.public_virginia.id
  route_table_id = aws_route_table.public_rt_virginia.id
}

# 버지니아 프라이빗 라우팅 테이블
resource "aws_route_table" "private_rt_virginia" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id
  tags = {
    Name = "CV_Private_RT_virginia"
  }
}

resource "aws_route" "private_route_virginia" {
  provider              = aws.virginia
  route_table_id        = aws_route_table.private_rt_virginia.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_virginia.id
}

resource "aws_route_table_association" "private_rt_assoc_virginia" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.private_virginia.id
  route_table_id = aws_route_table.private_rt_virginia.id
}
