provider "aws" {
  region = var.region
}

module "sns" {
  source           = "./modules/sns"
  environment      = var.environment
  subscriber_email = var.subscriber_email
}

module "lambda" {
  source        = "./modules/lambda"
  sns_topic_arn = module.sns.sns_topic_arn
  environment   = var.environment
  zip_path      = var.zip_path
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  lambda_arn  = module.lambda.lambda_arn
  environment = var.environment
}
