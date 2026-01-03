# Core Inputs (Phase 1)

variable "name" {
  type        = string
  description = "Name prefix for frontend resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags to apply to resources"
}

# Phase 2 Inputs (Custom Domain + TLS)

variable "custom_domain" {
  type        = string
  default     = null
  description = "Optional custom domain name for CloudFront (e.g. app.example.com)"
}

variable "acm_certificate_arn" {
  type        = string
  default     = null
  description = "Optional ACM certificate ARN (must be in us-east-1 for CloudFront)"
}

# Phase 2 Inputs (API Gateway)

variable "api_origin_domain" {
  type        = string
  default     = null
  description = "API Gateway domain (without https://) used as CloudFront origin for /api/*"
}
