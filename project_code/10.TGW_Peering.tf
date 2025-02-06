resource "aws_ec2_transit_gateway_peering_attachment" "CV_tgw_peering" {
  provider = aws.seoul
  transit_gateway_id        = aws_ec2_transit_gateway.CV_seoul_tgw.id
  peer_transit_gateway_id   = aws_ec2_transit_gateway.CV_virginia_tgw.id
  peer_region               = "us-east-1"

  tags = {
    Name = "CV_tgw_peering"
  }
}
