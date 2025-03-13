resource "aws_cloudfront_distribution" "cdn" {
  provider = aws.virginia

  wait_for_deployment = false

  origin {
    domain_name = aws_api_gateway_domain_name.api.domain_name
    origin_id   = "api-gw-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = ""

  aliases = ["*.wonkeun.shop"]  # ✅ CloudFront에서 사용할 도메인

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "DELETE", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-gw-origin"

    forwarded_values {
      query_string = true

      headers = ["Authorization", "Content-Type"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 600
  }

  restrictions {  # ✅ 추가된 블록 (필수)
    geo_restriction {
      restriction_type = "none"  # ✅ 모든 지역에서 접근 허용
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn  # ✅ CloudFront용 ACM 인증서
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}

# ✅ Route 53을 CloudFront로 연결
resource "aws_route53_record" "cloudfront" {
  provider = aws.seoul
  zone_id  = data.aws_route53_zone.host.id
  name     = "boyager"
  type     = "CNAME"
  ttl      = 300
  records  = [aws_cloudfront_distribution.cdn.domain_name]
}