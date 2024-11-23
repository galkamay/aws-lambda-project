variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "reviewer_email" {
  description = "The email address to subscribe to the topic"
  type        = string
}
