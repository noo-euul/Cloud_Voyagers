resource "aws_eip" "CV_seoul_nat_eip" {
  provider = aws.seoul
}

resource "aws_nat_gateway" "CV_seoul_nat" {
  provider      = aws.seoul
  subnet_id     = aws_subnet.CV_public_seoul_a.id
  allocation_id = aws_eip.CV_seoul_nat_eip.id

  tags = {
    Name = "CV_seoul_nat"
  }
}

resource "aws_eip" "CV_virginia_nat_eip" {
  provider = aws.virginia
}

resource "aws_nat_gateway" "CV_virginia_nat" {
  provider      = aws.virginia
  subnet_id     = aws_subnet.CV_public_virginia_a.id
  allocation_id = aws_eip.CV_virginia_nat_eip.id

  tags = {
    Name = "CV_virginia_nat"
  }
}
