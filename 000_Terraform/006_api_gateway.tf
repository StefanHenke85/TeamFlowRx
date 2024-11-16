# API Gateway REST API
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "${var.environment}_api"
  description = "API Gateway for ${var.environment} environment"

  tags = {
    Name        = "APIGateway"
    Environment = var.environment
  }
}

# Root resource ("/") of the API
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "root"
}

# Method for handling GET requests
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE" # Optional: Use "AWS_IAM" for secure authorization
}

# Integration with EC2
resource "aws_api_gateway_integration" "ec2_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get_method.http_method
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = var.backend_url # URL of the EC2 or Load Balancer
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_integration.ec2_integration,
  ]
}
