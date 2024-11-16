output "iam_role_arn" {
  description = "The ARN of the IAM role created for EC2 CloudWatch"
  value       = aws_iam_role.ec2_cloudwatch_role.arn
}

output "iam_policy_arn" {
  description = "The ARN of the CloudWatch Logs policy attached to the IAM role"
  value       = aws_iam_policy.cloudwatch_logs_policy.arn
}
