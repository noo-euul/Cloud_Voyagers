# Transit Gateway 생성
resource "aws_ec2_transit_gateway" "seoul_tgw" {
  provider = aws.seoul
  tags = {
    Name = "CV_TGW_Seoul"
  }
}

resource "aws_ec2_transit_gateway" "virginia_tgw" {
  provider = aws.virginia
  tags = {
    Name = "CV_TGW_Virginia"
  }
}