resource "aws_ec2_transit_gateway" "cv_transit_gateway" {
  description = "CV Transit Gateway"
  amazon_side_asn = 64512

  tags = {
    Name = "CV_Transit_Gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "seoul_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.cv_transit_gateway.id
  vpc_id = aws_vpc.seoul.id
  subnet_ids = aws_subnet.seoul_public_subnet.*.id

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Seoul"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "virginia_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.cv_transit_gateway.id
  vpc_id = aws_vpc.virginia.id
  subnet_ids = aws_subnet.virginia_public_subnet.*.id

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Virginia"
  }
}