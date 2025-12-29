output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name for the frontend"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted Zone ID for CloudFront"
  value       = aws_cloudfront_distribution.cdn.hosted_zone_id
}
