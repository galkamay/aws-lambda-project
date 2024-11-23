output "lambda_invoke_arn" {
  value       = aws_lambda_function.sum_function.invoke_arn
  description = "The ARN to invoke the Lambda function"
}
