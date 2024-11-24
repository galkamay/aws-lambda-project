variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "subscriber_email" {
  description = "Email address to subscribe to SNS topic"
  type        = string
}

variable "zip_path" {
  description = "Path to the zipped Lambda function"
  type        = string
}
