resource "aws_lambda_function" "sum_function" {
  function_name    = var.lambda_function_name
  runtime          = "python3.9"
  handler          = "app.lambda_handler"
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  role             = var.lambda_exec_role_arn

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}
