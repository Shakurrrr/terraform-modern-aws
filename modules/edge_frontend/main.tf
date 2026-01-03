# S3 Frontend Bucket (Private + Encrypted)


resource "aws_s3_bucket" "frontend" {
  bucket = var.name
  force_destroy = true
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CloudFront Origin Access Control (OAC)


resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.name}-oac"
  description                       = "OAC for ${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution (Phase 2 Extended)


resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "Frontend CDN for ${var.name}"
  default_root_object = "index.html"

  # Origins

  # S3 Origin (Phase 1)
  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "s3-frontend"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # API Gateway Origin (Phase 2) - Optional
  dynamic "origin" {
    for_each = var.api_origin_domain != null ? [1] : []

    content {
      domain_name = var.api_origin_domain
      origin_id   = "api-origin"

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  # Default Cache Behavior (Frontend)

  default_cache_behavior {
    target_origin_id       = "s3-frontend"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Ordered Cache Behavior (API Routing)

  dynamic "ordered_cache_behavior" {
    for_each = var.api_origin_domain != null ? [1] : []

    content {
      path_pattern           = "/api/*"
      target_origin_id       = "api-origin"
      viewer_protocol_policy = "redirect-to-https"

      # Allow full API methods
      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values {
        query_string = true

        # Forward required headers for APIs
        headers = ["Origin", "Authorization", "Content-Type"]

        cookies {
          forward = "none"
        }
      }

      # Disable caching for API requests
      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0
    }
  }

  # Custom Domain + ACM Support (Phase 2)

  aliases = var.custom_domain != null ? [var.custom_domain] : []

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn

    ssl_support_method       = var.acm_certificate_arn == null ? null : "sni-only"
    minimum_protocol_version = var.acm_certificate_arn == null ? null : "TLSv1.2_2021"
  }

  # Restrictions

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags

  tags = var.tags
}

# Bucket Policy (Allow CloudFront Read Only)

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid     = "AllowCloudFrontRead"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
