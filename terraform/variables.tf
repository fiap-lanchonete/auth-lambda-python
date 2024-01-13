variable "region" {
  description = "AWS Region"
  type = string
  default = "us-east-2"
}

variable "source_code_path" {
  description = "Path for the Lambda source code"
  type = string
  default = "../code/auth"
}
