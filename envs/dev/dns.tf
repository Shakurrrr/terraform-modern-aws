resource "aws_route53_record" "cdn_alias" {
  zone_id = module.dns.zone_id
  name    = "app"
  type    = "A"

  alias {
    name                   = module.edge_frontend.cloudfront_domain_name
    zone_id                = module.edge_frontend.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
