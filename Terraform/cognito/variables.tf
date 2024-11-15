# cognito/variables.tf

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "callback_url" {
  description = "The URL to redirect after successful login"
  type        = string
}

variable "logout_url" {
  description = "The URL to redirect after logout"
  type        = string
}
