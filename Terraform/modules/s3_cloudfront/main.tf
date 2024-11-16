# S3 Bucket for hosting static content
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "MoveToIA"
    enabled = true  # Corrected: Use "enabled" instead of "status"

    transition {
      days          = 30  # Move to Standard-IA after 30 days
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "MoveToGlacier"
    enabled = true  # Corrected: Use "enabled" instead of "status"

    transition {
      days          = 90  # Move to Glacier after 90 days
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "ExpireAfter"
    enabled = true  # Corrected: Use "enabled" instead of "status"

    expiration {
      days = 365  # Delete objects after 365 days
    }
  }

  tags = {
    Name        = "WebBucket"
    Environment = var.environment
  }
}

# S3 Bucket Policy to allow public access
resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.web_bucket.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution for the S3 bucket
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.web_bucket.bucket_regional_domain_name
    origin_id   = "S3-WebBucket"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for Web Application"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-WebBucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method   = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "CloudFrontCDN"
    Environment = var.environment
  }
}
