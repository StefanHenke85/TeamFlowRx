# Alarm für hohe CPU-Auslastung
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "${var.environment}_high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.backend_server.id
  }

  tags = {
    Environment = var.environment
  }
}

# Alarm für 5XX-Fehler im API Gateway
resource "aws_cloudwatch_metric_alarm" "api_5xx_errors_alarm" {
  alarm_name          = "${var.environment}_api_5xx_errors_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    ApiName = aws_api_gateway_rest_api.my_api.name
  }

  tags = {
    Environment = var.environment
  }
}
