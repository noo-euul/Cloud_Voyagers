resource "aws_ec2_transit_gateway" "CV_seoul_tgw" {
  provider = aws.seoul
  tags = {
    Name = "CV_seoul_tgw"
  }
}

resource "aws_ec2_transit_gateway" "CV_virginia_tgw" {
  provider = aws.virginia
  tags = {
    Name = "CV_virginia_tgw"
  }
}
