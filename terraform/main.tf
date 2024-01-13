provider "aws" {
  region = var.region
}

module "lambda" {
  source = "./modules/lambda"

  source_code_path = var.source_code_path
}

module "api_gateway" {
  source = "./modules/api-gateway"

  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_arn
}
