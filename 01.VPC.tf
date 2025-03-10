
resource "aws_vpc" "CV_seoul_vpc" {
  provider   = aws.seoul
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CV_seoul_vpc"
  }

  enable_dns_support   = true   #  내부 DNS 해석 활성화 (Lambda → FastAPI 연결 시 필수)
  enable_dns_hostnames = true   #  프라이빗 서브넷에서 DNS 이름 활성화
}

resource "aws_vpc" "CV_virginia_vpc" {
  provider   = aws.virginia
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "CV_virginia_vpc"
  }

  enable_dns_support   = true   #  내부 DNS 해석 활성화 (Lambda → FastAPI 연결 시 필수)
  enable_dns_hostnames = true   #  프라이빗 서브넷에서 DNS 이름 활성화
}

##################################################################
##################################################################

resource "aws_default_security_group" "default_sg_ko" {
  provider = aws.seoul
  vpc_id = aws_vpc.CV_seoul_vpc.id
  tags = { Name = "default_sg_ko" }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_default_security_group" "default_sg_us" {
  provider = aws.virginia
  vpc_id = aws_vpc.CV_virginia_vpc.id
  tags = { Name = "default_sg_us" }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

##################################################################
##################################################################

resource "aws_vpc_dhcp_options" "custom_dhcp" {
  provider = aws.seoul
  domain_name_servers = ["10.0.0.2", "169.254.169.253"]
  domain_name         = "ap-northeast-2.compute.internal" # AWS 내부 도메인
}

resource "aws_vpc_dhcp_options_association" "dhcp_association" {
  provider = aws.seoul
  vpc_id          = aws_vpc.CV_seoul_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.custom_dhcp.id

  depends_on = [ aws_vpc.CV_seoul_vpc ]
}

resource "aws_vpc_dhcp_options" "custom_dhcp_us" {
  provider = aws.virginia
  domain_name_servers = ["10.1.0.2", "169.254.169.253"]
  domain_name         = "us-east-1.compute.internal" # AWS 내부 도메인
}

resource "aws_vpc_dhcp_options_association" "dhcp_association_us" {
  provider = aws.virginia
  vpc_id          = aws_vpc.CV_virginia_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.custom_dhcp_us.id

  depends_on = [ aws_vpc.CV_virginia_vpc ]
}

##################################################################
##################################################################

resource "aws_subnet" "CV_public_seoul_a" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_seoul_a"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_subnet" "CV_public_seoul_c" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_seoul_c"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_subnet" "CV_private_seoul_a" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "CV_private_seoul_a"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_subnet" "CV_private_seoul_c" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "CV_private_seoul_c"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

##################################################################

resource "aws_subnet" "CV_public_virginia_a" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_virginia_a"
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

resource "aws_subnet" "CV_public_virginia_c" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "CV_public_virginia_c"
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

resource "aws_subnet" "CV_private_virginia_a" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "CV_private_virginia_a"
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

resource "aws_subnet" "CV_private_virginia_c" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "CV_private_virginia_c"
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

##################################################################
##################################################################

resource "aws_internet_gateway" "CV_seoul_igw" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id

  tags = {
    Name = "CV_seoul_igw"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_internet_gateway" "CV_virginia_igw" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  tags = {
    Name = "CV_virginia_igw"
  }

  depends_on = [ aws_vpc.CV_virginia_vpc]
}

##################################################################
##################################################################

resource "aws_eip" "CV_seoul_nat_eip" {
  provider = aws.seoul
}

resource "aws_eip" "CV_virginia_nat_eip" {
  provider = aws.virginia
}

##################################################################
##################################################################

resource "aws_nat_gateway" "CV_seoul_nat" {
  provider      = aws.seoul
  subnet_id     = aws_subnet.CV_public_seoul_a.id
  allocation_id = aws_eip.CV_seoul_nat_eip.id

  tags = {
    Name = "CV_seoul_nat"
  }

  depends_on = [ aws_eip.CV_seoul_nat_eip]
}

resource "aws_nat_gateway" "CV_virginia_nat" {
  provider      = aws.virginia
  subnet_id     = aws_subnet.CV_public_virginia_a.id
  allocation_id = aws_eip.CV_virginia_nat_eip.id

  tags = {
    Name = "CV_virginia_nat"
  }

  depends_on = [ aws_eip.CV_virginia_nat_eip]
}

##################################################################
##################################################################

resource "aws_ec2_transit_gateway" "CV_seoul_tgw" {
  provider = aws.seoul
  tags = {
    Name = "CV_seoul_tgw"
  }
  amazon_side_asn    = 64512
  default_route_table_association = "enable"
  default_route_table_propagation = "disable"

  dns_support = "enable"  # ✅ DNS 해석 활성화
  vpn_ecmp_support = "enable"
}

resource "aws_ec2_transit_gateway" "CV_virginia_tgw" {
  provider = aws.virginia
  tags = {
    Name = "CV_virginia_tgw"
  }
  amazon_side_asn    = 64513
  default_route_table_association = "enable"
  default_route_table_propagation = "disable"

  dns_support = "enable"  # ✅ DNS 해석 활성화
  vpn_ecmp_support = "enable"
}



resource "aws_ec2_transit_gateway_vpc_attachment" "CV_seoul_vpc_attachment" {
  provider           = aws.seoul
  transit_gateway_id = aws_ec2_transit_gateway.CV_seoul_tgw.id
  vpc_id             = aws_vpc.CV_seoul_vpc.id
  subnet_ids         = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id] 

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Seoul"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "CV_virginia_vpc_attachment" {
  provider           = aws.virginia
  transit_gateway_id = aws_ec2_transit_gateway.CV_virginia_tgw.id
  vpc_id             = aws_vpc.CV_virginia_vpc.id
  subnet_ids         = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]

  tags = {
    Name = "CV_Transit_Gateway_Attachment_Virginia"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider                    = aws.seoul
  transit_gateway_id          = aws_ec2_transit_gateway.CV_seoul_tgw.id
  peer_transit_gateway_id     = aws_ec2_transit_gateway.CV_virginia_tgw.id
  peer_region                 = "us-east-1"
  tags = {
    Name = "Seoul-to-Virginia-TGW-Peering"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering_accept" {
  provider                  = aws.virginia
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  tags = {
    Name = "Virginia-Accept-Seoul-TGW"
  }
}

resource "aws_ec2_transit_gateway_route" "CV_seoul_to_virginia" {
  provider               = aws.seoul
  destination_cidr_block = "10.1.0.0/16"  # 버지니아 VPC CIDR
  transit_gateway_route_table_id = aws_ec2_transit_gateway.CV_seoul_tgw.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id

  depends_on = [ aws_ec2_transit_gateway_peering_attachment.tgw_peering, aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accept ]
}

resource "aws_ec2_transit_gateway_route" "CV_virginia_to_seoul" {
  provider               = aws.virginia
  destination_cidr_block = "10.0.0.0/16"  # 서울 VPC CIDR
  transit_gateway_route_table_id = aws_ec2_transit_gateway.CV_virginia_tgw.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accept.id
}

##################################################################
##################################################################

resource "aws_vpn_gateway" "CV_seoul_vgw" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
}

resource "aws_customer_gateway" "CV_seoul_cgw" {
  provider = aws.seoul
  bgp_asn    = 65000
  ip_address = "121.134.211.97"  # 온프레미스 공인 IP
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn_onprem" {
  provider            = aws.seoul
  customer_gateway_id = aws_customer_gateway.CV_seoul_cgw.id
  type                = "ipsec.1"
  vpn_gateway_id      = aws_vpn_gateway.CV_seoul_vgw.id
  static_routes_only  = true

  tunnel1_inside_cidr = "169.254.10.0/30"
  tunnel1_preshared_key = "vpnkey123"

  tunnel2_inside_cidr = "169.254.20.0/30"
  tunnel2_preshared_key = "vpnkey123"
}

resource "aws_vpn_connection_route" "seoul_vpn_route" {
  provider           = aws.seoul
  vpn_connection_id  = aws_vpn_connection.vpn_onprem.id
  destination_cidr_block = "192.168.10.0/24" # 온프레미스 네트워크 CIDR
}

##################################################################

resource "aws_vpn_gateway" "CV_virginia_vgw" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
}

resource "aws_customer_gateway" "CV_virginia_cgw" {
  provider = aws.virginia
  bgp_asn    = 65000
  ip_address = "121.134.211.97"  # 온프레미스 공인 IP
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn_onprem_us" {
  provider            = aws.virginia
  customer_gateway_id = aws_customer_gateway.CV_virginia_cgw.id
  type                = "ipsec.1"
  vpn_gateway_id      = aws_vpn_gateway.CV_virginia_vgw.id  # ✅ transit_gateway_id → vpn_gateway_id 수정
  static_routes_only  = true

  tunnel1_inside_cidr = "169.254.10.0/30"
  tunnel1_preshared_key = "vpnkey123"

  tunnel2_inside_cidr = "169.254.20.0/30"
  tunnel2_preshared_key = "vpnkey123"
}

resource "aws_vpn_connection_route" "virginia_vpn_route" {
  provider           = aws.virginia
  vpn_connection_id  = aws_vpn_connection.vpn_onprem_us.id
  destination_cidr_block = "192.168.10.0/24" # 온프레미스 네트워크 CIDR
}

##################################################################
##################################################################

resource "aws_route_table" "CV_seoul_public_rt" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id

  tags = {
    Name = "CV_seoul_public_rt"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_route_table" "CV_seoul_private_rt" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id

  tags = {
    Name = "CV_seoul_private_rt"
  }

  depends_on = [ aws_vpc.CV_seoul_vpc]
}

resource "aws_route" "CV_seoul_public_route" {
  provider           = aws.seoul
  route_table_id     = aws_route_table.CV_seoul_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id        = aws_internet_gateway.CV_seoul_igw.id

   depends_on = [ aws_internet_gateway.CV_seoul_igw ]
}

resource "aws_route" "CV_seoul_private_nat_route" {
  provider           = aws.seoul
  route_table_id     = aws_route_table.CV_seoul_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id    = aws_nat_gateway.CV_seoul_nat.id

  depends_on = [ aws_nat_gateway.CV_seoul_nat ]
}

resource "aws_route" "CV_seoul_to_tgw" {
  provider               = aws.seoul
  route_table_id         = aws_route_table.CV_seoul_private_rt.id
  destination_cidr_block = "10.1.0.0/16"  
  transit_gateway_id     = aws_ec2_transit_gateway.CV_seoul_tgw.id

  depends_on = [ aws_ec2_transit_gateway.CV_seoul_tgw ]
}

resource "aws_route" "CV_seoul_to_vgw" {
  provider               = aws.seoul
  route_table_id         = aws_route_table.CV_seoul_private_rt.id
  destination_cidr_block = "192.168.10.0/24"  
  gateway_id             = aws_vpn_gateway.CV_seoul_vgw.id

  depends_on = [ aws_vpn_gateway.CV_seoul_vgw ]
}

resource "aws_route_table_association" "CV_seoul_public_rt_assoc_a" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_public_seoul_a.id
  route_table_id = aws_route_table.CV_seoul_public_rt.id

  depends_on = [ aws_route.CV_seoul_public_route]
}

resource "aws_route_table_association" "CV_seoul_public_rt_assoc_c" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_public_seoul_c.id
  route_table_id = aws_route_table.CV_seoul_public_rt.id

  depends_on = [ aws_route.CV_seoul_public_route]
}

resource "aws_route_table_association" "CV_seoul_private_rt_assoc_a" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_private_seoul_a.id
  route_table_id = aws_route_table.CV_seoul_private_rt.id

  //depends_on = [ aws_route.CV_seoul_private_nat_route, aws_route.CV_seoul_to_tgw]
}

resource "aws_route_table_association" "CV_seoul_private_rt_assoc_c" {
  provider       = aws.seoul
  subnet_id      = aws_subnet.CV_private_seoul_c.id
  route_table_id = aws_route_table.CV_seoul_private_rt.id

  //depends_on = [ aws_route.CV_seoul_private_nat_route , aws_route.CV_seoul_to_tgw]
}

##################################################################

resource "aws_route_table" "CV_virginia_public_rt" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  tags = {
    Name = "CV_virginia_public_rt"
  }
}

resource "aws_route_table" "CV_virginia_private_rt" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id

  tags = {
    Name = "CV_virginia_private_rt"
  }
}

resource "aws_route" "CV_virginia_public_route" {
  provider           = aws.virginia
  route_table_id     = aws_route_table.CV_virginia_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id        = aws_internet_gateway.CV_virginia_igw.id

  depends_on = [ aws_internet_gateway.CV_virginia_igw ]
}

resource "aws_route" "CV_virginia_private_nat_route" {
  provider           = aws.virginia
  route_table_id     = aws_route_table.CV_virginia_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id    = aws_nat_gateway.CV_virginia_nat.id

  depends_on = [ aws_nat_gateway.CV_virginia_nat ]
}

resource "aws_route" "CV_virginia_to_tgw" {
  provider               = aws.virginia
  route_table_id         = aws_route_table.CV_virginia_private_rt.id
  destination_cidr_block = "10.0.0.0/16"  
  transit_gateway_id     = aws_ec2_transit_gateway.CV_virginia_tgw.id

  depends_on = [ aws_ec2_transit_gateway.CV_virginia_tgw ]
}

resource "aws_route" "CV_virginia_to_vgw" {
  provider               = aws.virginia
  route_table_id         = aws_route_table.CV_virginia_private_rt.id
  destination_cidr_block = "192.168.10.0/24"  
  gateway_id             = aws_vpn_gateway.CV_virginia_vgw.id

  depends_on = [ aws_vpn_gateway.CV_virginia_vgw ]
}

resource "aws_route_table_association" "CV_virginia_public_rt_assoc_a" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_public_virginia_a.id
  route_table_id = aws_route_table.CV_virginia_public_rt.id
}

resource "aws_route_table_association" "CV_virginia_public_rt_assoc_c" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_public_virginia_c.id
  route_table_id = aws_route_table.CV_virginia_public_rt.id
}

resource "aws_route_table_association" "CV_virginia_private_rt_assoc_a" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_private_virginia_a.id
  route_table_id = aws_route_table.CV_virginia_private_rt.id

  //depends_on = [ aws_route.CV_virginia_private_nat_route , aws_route.CV_virginia_to_tgw]
}

resource "aws_route_table_association" "CV_virginia_private_rt_assoc_c" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.CV_private_virginia_c.id
  route_table_id = aws_route_table.CV_virginia_private_rt.id

  //depends_on = [ aws_route.CV_virginia_private_nat_route , aws_route.CV_virginia_to_tgw]
}

##################################################################
##################################################################


# resource "aws_network_acl" "eks_acl" {
#   vpc_id = aws_vpc.CV_seoul_vpc.id
#   tags = {
#     Name = "eks_acl"
#   }
# }

# resource "aws_network_acl_rule" "allow_eks_9100_inbound" {
#   network_acl_id = aws_network_acl.eks_acl.id
#   rule_number    = 130
#   protocol       = "tcp"
#   rule_action    = "allow"
#   egress         = false
#   cidr_block     = "10.0.0.0/16"
#   from_port      = 9100
#   to_port        = 9100
# }

# resource "aws_network_acl_rule" "allow_eks_9100_outbound" {
#   network_acl_id = aws_network_acl.eks_acl.id
#   rule_number    = 140
#   protocol       = "tcp"
#   rule_action    = "allow"
#   egress         = true
#   cidr_block     = "10.0.0.0/16"
#   from_port      = 9100
#   to_port        = 9100
# }

# resource "aws_route" "CV_seoul_public_to_private" {
#   provider               = aws.seoul
#   route_table_id         = aws_route_table.CV_seoul_public_rt.id
#   destination_cidr_block = "10.0.2.0/24"
#   gateway_id             = "local" 
# }

# resource "aws_route" "CV_seoul_public_to_private2" {
#   provider               = aws.seoul
#   route_table_id         = aws_route_table.CV_seoul_public_rt.id
#   destination_cidr_block = "10.0.4.0/24"
#   gateway_id             = "local" 
# }

# resource "aws_route" "CV_seoul_private_to_public" {
#   provider               = aws.seoul
#   route_table_id         = aws_route_table.CV_seoul_private_rt.id
#   destination_cidr_block = "10.0.1.0/24" 
#   gateway_id             = "local"
# }

# resource "aws_route" "CV_seoul_private_to_public2" {
#   provider               = aws.seoul
#   route_table_id         = aws_route_table.CV_seoul_private_rt.id
#   destination_cidr_block = "10.0.3.0/24" 
#   gateway_id             = "local"
# }