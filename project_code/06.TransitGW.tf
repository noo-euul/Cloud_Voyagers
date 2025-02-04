# 서울 Transit Gateway 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "seoul_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.cv_transit_gateway.id
  vpc_id = aws_vpc.seoul.id
  subnet_ids = [aws_subnet.public_seoul.id]  # 또는 aws_subnet.private_seoul.id

  tags = {
    Name = "CV_Transit_Gateway_Attachment_seoul"
  }
}

# 미국 버지니아 Transit Gateway 연결
resource "aws_ec2_transit_gateway_vpc_attachment" "virginia_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.cv_transit_gateway.id
  vpc_id = aws_vpc.virginia.id
  subnet_ids = [aws_subnet.public_virginia.id]  # 또는 aws_subnet.private_virginia.id

  tags = {
    Name = "CV_Transit_Gateway_Attachment_virginia"
  }
}
