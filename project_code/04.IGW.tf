resource "aws_internet_gateway" "CV_seoul_igw" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id

  tags = {
    Name = "CV_seoul_igw"
  }
}

resource "aws_internet_gateway" "CV_virginia_igw" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  tags = {
    Name = "CV_virginia_igw"
  }
}
