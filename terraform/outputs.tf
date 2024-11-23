output "api_gateway_url" {
  value       = module.api_gateway.api_gateway_url
  description = "The URL to invoke the API Gateway endpoint"
}

output "lambda_function_name" {
  value       = module.lambda.lambda_name
  description = "The name of the Lambda function"
}

output "sns_topic_arn" {
  value       = module.sns.sns_topic_arn
  description = "The ARN of the SNS topic"
}
