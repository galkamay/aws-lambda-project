variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "subscriber_email" {
  description = "Email address to subscribe to SNS topic"
  type        = string
}
