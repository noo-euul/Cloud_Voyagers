# 서울 IGW
resource "aws_internet_gateway" "igw_seoul" {
  vpc_id = aws_vpc.seoul.id
  tags = {
    Name = "CV_IGW_seoul"
  }
}

# 미국 버지니아 IGW
resource "aws_internet_gateway" "igw_virginia" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id
  tags = {
    Name = "CV_IGW_virginia"
  }
}