variable "api_gateway_name" {
  description = "Name for the API Gateway"
  type = string
  default = "auth_api_gateway"
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to invoke."
}

variable "lambda_function_name" {
  description = "Name of the Lambda function."
}
