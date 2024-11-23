provider "aws" {
  region = var.aws_region
}

module "sns" {
  source = "./modules/sns"
  sns_topic_name = var.sns_topic_name
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  sns_topic_arn        = module.sns.sns_topic_arn
  lambda_zip_path      = var.lambda_zip_path
}

module "api_gateway" {
  source = "./modules/api_gateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}
