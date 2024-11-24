variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the Lambda execution role"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "zip_path" {
  description = "Path to the zipped Lambda function"
  type        = string
}
