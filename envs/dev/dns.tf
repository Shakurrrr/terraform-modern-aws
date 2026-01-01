data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cdn_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "app"
  type    = "A"

  alias {
    name                   = module.edge_frontend.cloudfront_domain_name
    zone_id                = module.edge_frontend.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
