import json
import boto3
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Log everything at INFO level and above

def lambda_handler(event, context):
    # Log the received event
    logger.info(f"Received event: {json.dumps(event)}")

    # Validate input
    try:
        number1 = int(event['number1'])
        number2 = int(event['number2'])
    except KeyError as e:
        logger.error(f"Missing key in request: {str(e)}")
        return {
            "statusCode": 400,
            "body": json.dumps("Error: 'number1' and 'number2' are required.")
        }
    except ValueError as e:
        logger.error(f"Invalid value in request: {str(e)}")
        return {
            "statusCode": 400,
            "body": json.dumps("Error: 'number1' and 'number2' must be integers.")
        }

    # Calculate the sum
    result = number1 + number2
    logger.info(f"Calculated result: {result}")

    # Publish result to SNS
    sns_client = boto3.client('sns')
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']  # Topic ARN from environment variable
    try:
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=f"The sum of {number1} and {number2} is {result}."
        )
        logger.info("Message successfully published to SNS.")
    except Exception as e:
        logger.error(f"Failed to publish to SNS: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps("Error: Failed to publish to SNS.")
        }

    # Return the result
    return {
        "statusCode": 200,
        "body": json.dumps({"result": result})
    }
