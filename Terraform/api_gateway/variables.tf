# api_gateway/variables.tf

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "stage_name" {
  description = "The deployment stage (e.g., dev, prod)"
  type        = string
}

# Optional: Only needed if using EC2 as the integration target
# variable "ec2_endpoint" {
#   description = "The endpoint of the EC2 instance or load balancer"
#   type        = string
# }
