# cloudwatch/main.tf

# CloudWatch Log Group for Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.environment}_my_lambda"
  retention_in_days = 7  # Optional: Adjust retention period

  tags = {
    Name        = "LambdaLogGroup"
    Environment = var.environment
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api-gateway/${var.environment}_api"
  retention_in_days = 7

  tags = {
    Name        = "APIGatewayLogGroup"
    Environment = var.environment
  }
}

# CloudWatch Alarm for High CPU Usage on EC2 instance
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "${var.environment}_high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80  # Alarm if CPU usage exceeds 80%
  alarm_actions       = [var.alarm_topic_arn]
  dimensions = {
    InstanceId = var.ec2_instance_id
  }

  tags = {
    Name        = "HighCPUAlarm"
    Environment = var.environment
  }
}

# CloudWatch Alarm for API Gateway Errors
resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_alarm" {
  alarm_name          = "${var.environment}_api_gateway_5xx_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 1  # Alarm if there is at least one 5xx error
  alarm_actions       = [var.alarm_topic_arn]
  dimensions = {
    ApiName = aws_api_gateway_rest_api.my_api.name
  }

  tags = {
    Name        = "APIGateway5xxAlarm"
    Environment = var.environment
  }
}
