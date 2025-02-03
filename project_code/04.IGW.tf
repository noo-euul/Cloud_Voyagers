# 서울 IGW
resource "aws_internet_gateway" "igw_seoul" {
  vpc_id = aws_vpc.seoul.id
  tags = {
    Name = "CV_IGW_Seoul"
  }
}

# 프랑스 IGW
resource "aws_internet_gateway" "igw_france" {
  provider = aws.france
  vpc_id   = aws_vpc.france.id
  tags = {
    Name = "CV_IGW_France"
  }
}
