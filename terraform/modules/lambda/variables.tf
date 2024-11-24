variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "zip_path" {
  description = "Absolute path to the zipped Lambda function"
  type        = string
  default     = "${abspath("${path.module}/../lambda_function/function.zip")}"
}

