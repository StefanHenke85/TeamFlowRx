output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.my_api.id
}

output "api_endpoint" {
  description = "The endpoint of the API Gateway"
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
}
