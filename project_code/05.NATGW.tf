# 서울 NAT GW
resource "aws_eip" "nat_eip_seoul" {
  vpc = true
  tags = {
    Name = "CV_NAT_EIP_Seoul"
  }
}

resource "aws_nat_gateway" "nat_seoul" {
  allocation_id = aws_eip.nat_eip_seoul.id
  subnet_id     = aws_subnet.public_seoul.id
  tags = {
    Name = "CV_NAT_Seoul"
  }
}

# 프랑스 NAT GW
resource "aws_eip" "nat_eip_france" {
  provider = aws.france
  vpc      = true
  tags = {
    Name = "CV_NAT_EIP_France"
  }
}

resource "aws_nat_gateway" "nat_france" {
  provider      = aws.france
  allocation_id = aws_eip.nat_eip_france.id
  subnet_id     = aws_subnet.public_france.id
  tags = {
    Name = "CV_NAT_France"
  }
}
