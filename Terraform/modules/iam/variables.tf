variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "ec2_cloudwatch_role"
}

variable "policy_name" {
  description = "Name of the CloudWatch Logs policy to attach"
  type        = string
  default     = "cloudwatch_logs_policy"
}
