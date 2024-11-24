resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy-${var.environment}"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "lambda" {
  function_name    = "SumFunction-${var.environment}"
  runtime          = "python3.9"
  handler          = "app.lambda_handler"
  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}



