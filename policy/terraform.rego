package terraform.policies

deny[msg] {
  input.resource_changes[_].type == "aws_s3_bucket_public_access_block"
  input.resource_changes[_].change.after.block_public_acls == false
  msg := "S3 Public ACLs must be blocked"
}

deny[msg] {
  input.resource_changes[_].type == "aws_s3_bucket_public_access_block"
  input.resource_changes[_].change.after.block_public_policy == false
  msg := "S3 Public Bucket Policies must be blocked"
}

deny[msg] {
  input.resource_changes[_].type == "aws_cloudfront_distribution"
  input.resource_changes[_].change.after.default_cache_behavior.viewer_protocol_policy != "redirect-to-https"
  msg := "CloudFront must redirect viewers to HTTPS"
}
