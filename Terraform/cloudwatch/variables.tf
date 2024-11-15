# cloudwatch/variables.tf

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "alarm_topic_arn" {
  description = "The ARN of the SNS topic to send alarm notifications"
  type        = string
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance to monitor for CPU usage"
  type        = string
}

variable "api_gateway_id" {
  description = "The ID of the API Gateway to monitor for 5xx errors"
  type        = string
}
