provider "aws" {
  region = var.region
}

module "sns" {
  source           = "./modules/sns"
  environment      = var.environment
  subscriber_email = var.subscriber_email
}

module "lambda" {
  source               = "./modules/lambda"
  sns_topic_arn        = module.sns.sns_topic_arn
  zip_path             = var.zip_path
  lambda_function_name = "SumFunction-${var.environment}"
  lambda_role_name     = "lambda_exec_role-${var.environment}"
}

module "api_gateway" {
  source              = "./modules/api_gateway"
  lambda_arn          = module.lambda.lambda_arn
  lambda_function_name = module.lambda.lambda_name
  environment         = var.environment
  route_key           = "POST /sum"
  api_stage_name      = "prod"
}
