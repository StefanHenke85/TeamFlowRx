# rds_mysql/variables.tf

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
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

# Optional: KMS key ID for encryption at rest
# variable "kms_key_id" {
#   description = "The KMS key ID for database encryption"
#   type        = string
#   default     = null
# }
