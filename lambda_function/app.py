import json
import boto3
import os

def lambda_handler(event, context):
    # Read numbers from the event
    try:
        number1 = event['number1']  # Extract 'number1' from the event
        number2 = event['number2']  # Extract 'number2' from the event
    except KeyError:
        return {
            "statusCode": 400,  # Return 400 if input is missing
            "body": json.dumps("Error: Missing 'number1' or 'number2' in request.")
        }

    # Calculate the sum
    result = number1 + number2  # Add the two numbers

    # Publish the result to SNS
    sns_client = boto3.client('sns')  # Initialize SNS client
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']  # Get SNS Topic ARN from environment variables
    sns_client.publish(
        TopicArn=sns_topic_arn,  # The SNS Topic ARN
        Message=f"The sum of {number1} and {number2} is {result}."  # Message to publish
    )

    # Return the result
    return {
        "statusCode": 200,  # HTTP 200 success
        "body": json.dumps({"result": result})  # Return the sum in the response
    }
