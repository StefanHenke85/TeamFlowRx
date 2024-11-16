# Globale Umgebung
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# S3 und CloudFront
variable "bucket_name" {
  description = "The name of the S3 bucket for hosting static content"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for HTTPS"
  type        = string
}

# RDS MySQL
variable "db_username" {
  description = "The master username for the database"
  type        = string
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The VPC ID where the database and other resources will be deployed"
  type        = string
}

variable "backend_cidr_blocks" {
  description = "The CIDR blocks of the backend EC2 instances that need database access"
  type        = list(string)
}

# IAM
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

variable "rds_role_name" {
  description = "Name of the IAM role for RDS access"
  type        = string
  default     = "rds_access_role"
}

# Cognito
variable "callback_urls" {
  description = "List of allowed callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://example.com/callback"]
}

variable "logout_urls" {
  description = "List of allowed logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://example.com/logout"]
}

# CloudWatch
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

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group"
  type        = string
}

# Autoscaling
variable "image_id" {
  description = "AMI ID for the instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Autoscaling group"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the Autoscaling group"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for the launch template"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the instances"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for the Autoscaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the Autoscaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the Autoscaling group"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
  type        = string
}

# API Gateway
variable "stage_name" {
  description = "The deployment stage (e.g., dev, prod)"
  type        = string
}

variable "backend_url" {
  description = "The URL of the EC2 instance or Load Balancer"
  type        = string
}

# EC2
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "key_pair_name" {
  description = "The key pair name for SSH access"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "The CIDR blocks allowed to access the EC2 instance via SSH"
  type        = list(string)
}
