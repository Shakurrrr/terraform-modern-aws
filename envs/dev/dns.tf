locals {
  dns_enabled = var.enable_dns && var.domain_name != ""
}

data "aws_route53_zone" "primary" {
  count        = local.dns_enabled ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cdn_alias" {
  count   = local.dns_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.primary[0].zone_id
  name    = "app"
  type    = "A"

  alias {
    name                   = module.edge_frontend.cloudfront_domain_name
    zone_id                = module.edge_frontend.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
