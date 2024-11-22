provider "aws" {
  region = "us-east-1"
}

# Create IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
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

# Attach IAM Policy to Lambda Role
resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy"
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

# Create SNS Topic
resource "aws_sns_topic" "sum_topic" {
  name = "lambda-sum-topic"
}

# Create Lambda Function
resource "aws_lambda_function" "sum_function" {
  function_name    = "SumFunction"
  runtime          = "python3.9"
  handler          = "app.lambda_handler"
  filename         = "C:/Users/User/source/repos/aws-lambda-project/lambda_function/function.zip"
  source_code_hash = filebase64sha256("C:/Users/User/source/repos/aws-lambda-project/lambda_function/function.zip")

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.sum_topic.arn
    }
  }
}

# Create API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "lambda-api"
  protocol_type = "HTTP"
}

# Integrate API Gateway with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.sum_function.invoke_arn
  payload_format_version = "2.0"
}

# Create API Gateway Route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /sum"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Deploy the API Gateway
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "prod"
  auto_deploy = true
}

# Add permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sum_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*"
}

# Outputs
output "api_gateway_url" {
  value       = aws_apigatewayv2_stage.api_stage.invoke_url
  description = "The URL to invoke the API Gateway endpoint"
}

output "lambda_function_name" {
  value       = aws_lambda_function.sum_function.function_name
  description = "The name of the Lambda function"
}

output "sns_topic_arn" {
  value       = aws_sns_topic.sum_topic.arn
  description = "The ARN of the SNS topic"
}
