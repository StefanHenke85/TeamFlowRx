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

output "rds_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = aws_db_instance.mysql_db.endpoint
}

output "rds_security_group_id" {
  description = "The ID of the security group for RDS MySQL"
  value       = aws_security_group.db_access_sg.id
}


output "iam_policy_arn" {
  description = "The ARN of the CloudWatch Logs policy attached to the IAM role"
  value       = aws_iam_policy.cloudwatch_logs_policy.arn
}
output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.id
}

output "user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.user_pool_client.id
}

output "identity_pool_id" {
  description = "ID of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.identity_pool.id
}

output "authenticated_role_arn" {
  description = "ARN of the IAM Role for authenticated users"
  value       = aws_iam_role.authenticated_role.arn
}
# cloudwatch/outputs.tf

output "lambda_log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

output "api_gateway_log_group_name" {
  description = "The name of the CloudWatch log group for the API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway_log_group.name
}


output "api_gateway_5xx_alarm_arn" {
  description = "The ARN of the API Gateway 5xx error alarm"
  value       = aws_cloudwatch_metric_alarm.api_gateway_5xx_alarm.arn
}
output "autoscaling_group_name" {
  description = "Name of the Autoscaling group"
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.app_lt.id
}

output "scaling_policy_out_name" {
  description = "Name of the scale-out policy"
  value       = aws_autoscaling_policy.scale_out.name
}

output "scaling_policy_in_name" {
  description = "Name of the scale-in policy"
  value       = aws_autoscaling_policy.scale_in.name
}
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_lb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}
output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.my_api.id
}

output "api_endpoint" {
  description = "The endpoint of the API Gateway"
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
}
# ec2/outputs.tf

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.backend_server.id
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.backend_server.public_ip
}
