# cloudwatch/outputs.tf

output "lambda_log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

output "api_gateway_log_group_name" {
  description = "The name of the CloudWatch log group for the API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway_log_group.name
}

output "high_cpu_alarm_arn" {
  description = "The ARN of the high CPU alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu_alarm.arn
}

output "api_gateway_5xx_alarm_arn" {
  description = "The ARN of the API Gateway 5xx error alarm"
  value       = aws_cloudwatch_metric_alarm.api_gateway_5xx_alarm.arn
}
