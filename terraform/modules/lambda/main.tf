resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "auth_lambda" {
  function_name = var.function_name
  filename = var.filename
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  handler      = var.handler_name
  runtime      = var.runtime_version
  timeout      = var.timeout

  role = aws_iam_role.iam_for_lambda.arn
}

resource "aws_cloudwatch_log_group" "auth_lambda" {
  name = "/aws/lambda/${aws_lambda_function.auth_lambda.function_name}"

  retention_in_days = 7
}

resource "aws_lambda_permission" "logs_lambda_permission" {
  statement_id  = "AllowLogging"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_lambda.function_name
  principal     = "logs.amazonaws.com"
  source_arn   = aws_cloudwatch_log_group.auth_lambda.arn
}

data "archive_file" "python_lambda_package" {
  type = "zip"
  source_dir = var.source_code_path
  output_path = var.filename
}
