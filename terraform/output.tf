output "api_gateway_url" {
  description = "Base URL for API Gateway stage"
  value = module.api_gateway.api_gateway_url
}
output "lambda_function_arn" {
  description = "Lambda function ARN"
  value = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value = module.lambda.lambda_function_name
}
