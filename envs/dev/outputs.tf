##############################################
# Frontend Outputs
##############################################

output "cloudfront_domain_name" {
  description = "CloudFront domain name for the frontend"
  value       = module.edge_frontend.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.edge_frontend.cloudfront_distribution_id
}

##############################################
# Backend API Outputs
##############################################

output "api_endpoint" {
  description = "Direct API Gateway endpoint"
  value       = module.api_gateway.api_endpoint
}

output "api_domain" {
  description = "API Gateway domain without https:// for CloudFront origin"
  value       = replace(module.api_gateway.api_endpoint, "https://", "")
}
