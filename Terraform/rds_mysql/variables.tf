variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

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
  description = "The VPC ID where the database will be deployed"
  type        = string
}

variable "backend_cidr_blocks" {
  description = "The CIDR blocks of the backend EC2 instances that need database access"
  type        = list(string)
}
