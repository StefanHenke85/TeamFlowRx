variable "environment" {
  description = "The environment for the Cognito resources (e.g., dev, staging, prod)"
  type        = string
}

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
