resource "aws_route53_record" "app_record" {
  zone_id = var.zone_id
  name    = var.app_subdomain
  type    = "A"

  alias {
    name                   = var.app_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_record" {
  zone_id = var.zone_id
  name    = var.api_subdomain
  type    = "A"

  alias {
    name                   = var.api_distribution_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
