output "high_cpu_alarm_arn" {
  description = "The ARN of the high CPU CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu_alarm.arn
}

output "api_5xx_errors_alarm_arn" {
  description = "The ARN of the API Gateway 5XX errors alarm"
  value       = aws_cloudwatch_metric_alarm.api_5xx_errors_alarm.arn
}
