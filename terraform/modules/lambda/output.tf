output "lambda_function_arn" {
  description = "Lambda function arn"
  value = aws_lambda_function.auth_lambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.auth_lambda.function_name
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.auth_lambda.name
}

