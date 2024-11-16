output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.web_bucket.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}
