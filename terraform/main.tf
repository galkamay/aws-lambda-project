# Specify AWS provider and region
provider "aws" {
  region = "us-east-1"  # Set the region
}

# Create an SNS Topic
resource "aws_sns_topic" "sum_topic" {
  name = "lambda-sum-topic"  # Name of the SNS topic
}

# Create a Lambda function
resource "aws_lambda_function" "sum_function" {
  function_name = "SumFunction"  # Name of the Lambda function
  runtime       = "python3.9"   # Python runtime
  handler       = "app.lambda_handler"  # Entry point for Lambda
  filename = "C:/Users/User/source/repos/aws-lambda-project/lambda_function/function.zip"  # Path to the function ZIP file

  # Specify IAM role for the Lambda function
  role = aws_iam_role.lambda_exec.arn

  # Pass environment variables to the Lambda function
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.sum_topic.arn  # Pass the SNS Topic ARN
    }
  }
}

# Create IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"  # Name of the IAM role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",  # IAM policy version
    Statement = [{
      Effect = "Allow",  # Allow Lambda service to assume this role
      Principal = {
        Service = "lambda.amazonaws.com"  # Specify Lambda as the trusted service
      },
      Action = "sts:AssumeRole"  # Allow role assumption
    }]
  })
}

# Attach an IAM policy to the Lambda execution role
resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy"  # Name of the policy
  role = aws_iam_role.lambda_exec.id  # Attach the policy to the IAM role
  policy = jsonencode({
    Version = "2012-10-17",  # IAM policy version
    Statement = [
      {
        Effect = "Allow",  # Allow access
        Action = [
          "logs:*",      # Allow Lambda to write logs
          "sns:Publish"  # Allow Lambda to publish to SNS
        ],
        Resource = "*"  # Allow access to all resources (can be restricted further)
      }
    ]
  })
}
