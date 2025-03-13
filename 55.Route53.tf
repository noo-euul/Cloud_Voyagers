data "aws_route53_zone" "host" {
  provider = aws.seoul  # ✅ Route 53 Hosted Zone은 보통 서울 리전에 있음
  name     = "wonkeun.shop"
}

data "aws_acm_certificate" "cert" {
  provider    = aws.virginia  # ✅ ACM 인증서는 us-east-1 (버지니아)에서 관리됨
  domain      = "wonkeun.shop"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "api" {
  provider      = aws.virginia // east-1 필수
  domain_name  = "boyager.wonkeun.shop"
  certificate_arn = data.aws_acm_certificate.cert.arn
  
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_route53_record" "subdomain_cdn_record" {
  provider      = aws.virginia
  zone_id = data.aws_route53_zone.host.id
  name    = "boyager.wonkeun.shop"
  type    = "CNAME"
  ttl     = 300
  records = [aws_api_gateway_domain_name.api.cloudfront_domain_name]
}

resource "aws_api_gateway_base_path_mapping" "api_mapping" {
  provider      = aws.virginia
  domain_name = aws_api_gateway_domain_name.api.domain_name
  api_id = aws_api_gateway_rest_api.api_gateway_us.id
  stage_name  = "stage_01" # API Gateway에서 사용 중인 스테이지 이름 입력
  
   depends_on = [
    aws_api_gateway_rest_api.api_gateway_us,
    aws_api_gateway_domain_name.api,
    aws_route53_record.subdomain_cdn_record
  ]
}
