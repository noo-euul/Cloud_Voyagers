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

# 미국 버지니아 NAT GW
resource "aws_eip" "nat_eip_Virginia" {
  provider = aws.Virginia
  vpc      = true
  tags = {
    Name = "CV_NAT_EIP_Virginia"
  }
}

resource "aws_nat_gateway" "nat_Virginia" {
  provider      = aws.Virginia
  allocation_id = aws_eip.nat_eip_Virginia.id
  subnet_id     = aws_subnet.public_Virginia.id
  tags = {
    Name = "CV_NAT_Virginia"
  }
}
