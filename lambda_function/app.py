import json
import boto3
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

class LambdaError(Exception):
    """Custom exception for structured Lambda errors"""
    def __init__(self, status_code, error_type, message):
        self.status_code = status_code
        self.error_type = error_type
        self.message = message
        super().__init__(message)

def lambda_handler(event, context):
    try:
        # Log the received event
        logger.info(f"Received event: {json.dumps(event)}")

        # Parse the body from the event
        body = json.loads(event.get("body", "{}"))
        logger.info(f"Parsed body: {body}")

        # Validate input
        number1 = body.get('number1')
        number2 = body.get('number2')

        # Ensure the numbers are provided and are integers
        if number1 is None or number2 is None:
            raise LambdaError(400, "ValidationError", "Missing key: 'number1' and/or 'number2'")
        try:
            number1 = int(number1)
            number2 = int(number2)
        except ValueError:
            raise LambdaError(400, "ValidationError", "Invalid value: 'number1' and 'number2' must be integers.")

        # Calculate the sum
        result = number1 + number2
        logger.info(f"Calculated result: {result}")

        # Publish result to SNS
        sns_client = boto3.client('sns')
        sns_topic_arn = os.environ['SNS_TOPIC_ARN']
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=f"The sum of {number1} and {number2} is {result}."
        )
        logger.info("Message successfully published to SNS.")

        # Return successful response
        return {
            "statusCode": 200,
            "body": json.dumps({"result": result})
        }

    except LambdaError as le:
        logger.error(f"{le.error_type}: {le.message}")
        return {
            "statusCode": le.status_code,
            "body": json.dumps({"error": le.error_type, "message": le.message})
        }

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "InternalError", "message": "An unexpected error occurred."})
        }


    ##check2.7