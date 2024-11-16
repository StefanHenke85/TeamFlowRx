output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.web_bucket.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_lifecycle_rules" {
  description = "Lifecycle rules for the S3 bucket"
  value       = [
    {
      id             = "MoveToIA",
      transition_days = 30,
      storage_class  = "STANDARD_IA"
    },
    {
      id             = "MoveToGlacier",
      transition_days = 90,
      storage_class  = "GLACIER"
    },
    {
      id             = "ExpireAfter",
      expiration_days = 365
    }
  ]
}
