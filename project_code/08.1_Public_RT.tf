resource "aws_route_table" "CV_seoul_public_rt" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id

  tags = {
    Name = "CV_seoul_public_rt"
  }
}

resource "aws_route" "CV_seoul_public_route" {
  provider           = aws.seoul
  route_table_id     = aws_route_table.CV_seoul_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id        = aws_internet_gateway.CV_seoul_igw.id
}

resource "aws_route_table_association" "CV_seoul_public_rt_assoc_a" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_public_seoul_a.id
  route_table_id = aws_route_table.CV_seoul_public_rt.id
}

resource "aws_route_table_association" "CV_seoul_public_rt_assoc_c" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_public_seoul_c.id
  route_table_id = aws_route_table.CV_seoul_public_rt.id
}

resource "aws_route_table" "CV_virginia_public_rt" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  tags = {
    Name = "CV_virginia_public_rt"
  }
}

resource "aws_route" "CV_virginia_public_route" {
  provider           = aws.virginia
  route_table_id     = aws_route_table.CV_virginia_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id        = aws_internet_gateway.CV_virginia_igw.id
}

resource "aws_route_table_association" "CV_virginia_public_rt_assoc_a" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_public_virginia_a.id
  route_table_id = aws_route_table.CV_virginia_public_rt.id
}

resource "aws_route_table_association" "CV_virginia_public_rt_assoc_c" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_public_virginia_c.id
  route_table_id = aws_route_table.CV_virginia_public_rt.id
}
