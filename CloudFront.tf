resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "HelloWorld.html"
  price_class         = "PriceClass_All"
  http_version        = "http2and3"
  retain_on_delete    = false
  wait_for_deployment = true

  aliases = [
    var.dennis_Domain,
  ]

  tags = {
    Name = "IU-Test-CloudFront-Terraform"
  }

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id = var.dennis_Domain

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = var.dennis_Domain
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    compress = true
    min_ttl  = 0
    default_ttl = 0
    max_ttl = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

}