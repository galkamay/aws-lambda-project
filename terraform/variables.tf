variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "sns_topic_name" {
  description = "Name of the SNS Topic"
  default     = "lambda-sum-topic"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "SumFunction"
}

variable "lambda_zip_path" {
  description = "Path to the Lambda zip file"
  default     = "lambda_function.zip"
}
