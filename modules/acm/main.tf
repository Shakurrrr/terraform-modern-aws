variable "domain_name" {
  type = string
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "domain_validation_options" {
  value = aws_acm_certificate.cert.domain_validation_options
}
