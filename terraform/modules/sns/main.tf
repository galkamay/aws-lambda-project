resource "aws_sns_topic" "sns_topic" {
  name = "sns-topic-${var.environment}"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.subscriber_email
}
