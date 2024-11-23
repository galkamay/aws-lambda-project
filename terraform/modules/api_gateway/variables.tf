variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function"
  type        = string
}
