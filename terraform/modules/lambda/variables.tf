variable "filename" {
  description = "Name of the zip file"
  type = string
  default = "nametest.zip"
}

variable "source_code_path" {
  description = "Path to the Lambda function source code file."
}

variable "file_type" {
  description = "Type of the file"
  type = string
  default = "zip"
}

variable "function_name" {
  description = "Name of the function responsible for allowing authentication"
  type = string
  default = "auth-lambda"
}

variable "handler_name" {
  description = "Name of the python handler function"
  type = string
  default = "lambda_handler.lambda_handler"
}

variable "runtime_version" {
  description = "Runtime version for the Lambda function"
  type = string
  default = "python3.8"
}

variable "timeout" {
  description = "Timeout for the Lambda function"
  type = number
  default = 60
}
