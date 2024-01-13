output "api_gateway_url" {
  description = "Base URL for API Gateway stage."
  value = aws_apigatewayv2_stage.dev.invoke_url
}
