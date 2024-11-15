# Cognito User Pool for user authentication
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.environment}_user_pool"

  # Optional: Enforce password policies
  # password_policy {
  #   minimum_length                   = 8
  #   require_lowercase                = true
  #   require_numbers                  = true
  #   require_symbols                  = true
  #   require_uppercase                = true
  #   temporary_password_validity_days = 7
  # }

  # Optional: Enable Multi-Factor Authentication (MFA)
  # mfa_configuration = "OPTIONAL" # Use "ON" to enforce MFA
  # software_token_mfa_configuration {
  #   enabled = true
  # }

  auto_verified_attributes = ["email"]

  tags = {
    Name        = "CognitoUserPool"
    Environment = var.environment
  }
}

# Cognito User Pool Client for integration with front- and backend
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.environment}_user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  # Optional: Enable token validity periods for security
  # access_token_validity       = 60
  # id_token_validity           = 60
  # refresh_token_validity      = 30
  # token_validity_units {
  #   access_token  = "minutes"
  #   id_token      = "minutes"
  #   refresh_token = "days"
  # }

  allowed_oauth_flows       = ["code", "implicit"]
  allowed_oauth_scopes      = ["openid", "email", "profile"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [var.callback_url]
  logout_urls   = [var.logout_url]

  # Note: tags are not supported on aws_cognito_user_pool_client
}

# Optional: Cognito Identity Pool for federated identities (e.g., Google, Facebook)
# resource "aws_cognito_identity_pool" "identity_pool" {
#   identity_pool_name               = "${var.environment}_identity_pool"
#   allow_unauthenticated_identities = false
#   cognito_identity_providers {
#     client_id           = aws_cognito_user_pool_client.user_pool_client.id
#     provider_name       = aws_cognito_user_pool.user_pool.endpoint
#   }
# 
#   tags = {
#     Name        = "CognitoIdentityPool"
#     Environment = var.environment
#   }
# }
