variable "dennis_Domain"{
  default = "www.dennisloeffler.de"
}

#Zone von Route 53
data "aws_route53_zone" "dennis" {
  name         = "dennisloeffler.de."
  private_zone = false
}

# Leitet www.dennisloeffler.de auf CloudFront weiter
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.dennis.zone_id
  name    = "www.dennisloeffler.de"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}