variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "stage_name" {
  description = "The deployment stage (e.g., dev, prod)"
  type        = string
}

variable "backend_url" {
  description = "The URL of the EC2 instance or Load Balancer"
  type        = string
}
