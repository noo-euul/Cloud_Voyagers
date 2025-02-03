# 서울 IGW
resource "aws_internet_gateway" "igw_seoul" {
  vpc_id = aws_vpc.seoul.id
  tags = {
    Name = "CV_IGW_Seoul"
  }
}

# 미국 버지니아 IGW
resource "aws_internet_gateway" "igw_Virginia" {
  provider = aws.Virginia
  vpc_id   = aws_vpc.Virginia.id
  tags = {
    Name = "CV_IGW_Virginia"
  }
}
