# Cognito User Pool for user authentication
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.environment}_user_pool"

  # Enforce password policies for user security
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  # Enable Multi-Factor Authentication (MFA) (optional)
  mfa_configuration = "OPTIONAL" # Use "ON" to enforce MFA
  software_token_mfa_configuration {
    enabled = true
  }

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

  allowed_oauth_flows       = ["code", "implicit"]
  allowed_oauth_scopes      = ["openid", "email", "profile"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  # Note: tags are not supported on aws_cognito_user_pool_client
}

# Optional: Cognito Identity Pool for federated identities (e.g., Google, Facebook)
resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "${var.environment}_identity_pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.user_pool_client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }

  tags = {
    Name        = "CognitoIdentityPool"
    Environment = var.environment
  }
}

# IAM Role for authenticated users in the Identity Pool
resource "aws_iam_role" "authenticated_role" {
  name = "${var.environment}_cognito_authenticated_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.identity_pool.id
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "authenticated"
          }
        }
      }
    ]
  })
}

# Attach the role to the Identity Pool
resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    authenticated = aws_iam_role.authenticated_role.arn
  }
}
