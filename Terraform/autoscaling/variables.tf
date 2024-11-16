variable "environment" {
  description = "Environment for the resources"
  type        = string
}

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
