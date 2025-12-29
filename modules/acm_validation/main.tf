variable "zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "validation_options" {
  type = any
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in var.validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}
