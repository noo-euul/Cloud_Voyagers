# 서울 Transit Gateway VPC 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "seoul_vpc_attachment" {
  provider          = aws.seoul
  transit_gateway_id = aws_ec2_transit_gateway.seoul_tgw.id
  vpc_id             = aws_vpc.seoul.id
  subnet_ids         = [aws_subnet.public_seoul.id, aws_subnet.private_seoul.id]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Seoul"
  }
}

# 버지니아 Transit Gateway VPC 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "virginia_vpc_attachment" {
  provider          = aws.virginia
  transit_gateway_id = aws_ec2_transit_gateway.virginia_tgw.id
  vpc_id             = aws_vpc.virginia.id
  subnet_ids         = [aws_subnet.public_virginia.id, aws_subnet.private_virginia.id]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Virginia"
  }
}