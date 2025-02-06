resource "aws_route" "CV_seoul_to_tgw" {
  provider               = aws.seoul
  route_table_id         = aws_route_table.CV_seoul_private_rt.id
  destination_cidr_block = "10.1.0.0/16"  
  transit_gateway_id     = aws_ec2_transit_gateway.CV_seoul_tgw.id
}

resource "aws_route" "CV_virginia_to_tgw" {
  provider               = aws.virginia
  route_table_id         = aws_route_table.CV_virginia_private_rt.id
  destination_cidr_block = "10.0.0.0/16"  
  transit_gateway_id     = aws_ec2_transit_gateway.CV_virginia_tgw.id
}
