variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization to trigger an alarm"
  type        = number
  default     = 80
}

variable "api_5xx_threshold" {
  description = "Threshold for API Gateway 5XX errors to trigger an alarm"
  type        = number
  default     = 1
}

variable "alarm_actions" {
  description = "List of actions to perform when the alarm state changes"
  type        = list(string)
  default     = []
}
