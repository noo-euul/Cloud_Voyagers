# 서울 Transit Gateway VPC 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "CV_seoul_vpc_attachment" {
  provider           = aws.seoul
  transit_gateway_id = aws_ec2_transit_gateway.CV_seoul_tgw.id
  vpc_id             = aws_vpc.CV_seoul_vpc.id
  subnet_ids         = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Seoul"
  }
}

# 버지니아 Transit Gateway VPC 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "CV_virginia_vpc_attachment" {
  provider           = aws.virginia
  transit_gateway_id = aws_ec2_transit_gateway.CV_virginia_tgw.id
  vpc_id             = aws_vpc.CV_virginia_vpc.id
  subnet_ids         = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Virginia"
  }
}
