
# AWS Lambda API for Sum Calculation

This project demonstrates a serverless solution using AWS Lambda, API Gateway, and SNS. The API accepts two numbers as input, calculates their sum, and sends the result to an SNS topic. The system validates input data and handles errors gracefully.

---

## **Architecture**
1. **AWS Lambda**: Executes the logic for sum calculation and validates input.
2. **Amazon API Gateway**: Exposes the Lambda function as a RESTful HTTP API.
3. **Amazon SNS**: Publishes the result of the sum to subscribed endpoints (e.g., email).
4. **Terraform**: Automates the deployment of infrastructure.

---

## **Features**
- Validates input for completeness and type.
- Handles errors and returns descriptive messages for invalid inputs.
- Publishes the result to an SNS topic.
- Provides HTTP API for external access.

---

## **Setup Instructions**

### **1. Prerequisites**
- AWS CLI installed and configured.
- Terraform installed.
- An AWS account with permissions to manage Lambda, API Gateway, and SNS.
- Python 3.9 for developing the Lambda function.

---

### **2. Project Structure**
\`\`\`plaintext
aws-lambda-project/
├── lambda_function/
│   ├── app.py          # Lambda function code
│   └── function.zip    # Zipped Lambda function
├── terraform/
│   ├── main.tf         # Terraform configuration
│   ├── variables.tf    # Terraform variables (optional)
│   └── outputs.tf      # Terraform outputs
├── README.md           # Project documentation
\`\`\`

---

### **3. Deploying the Project**

#### **Step 1: Clone the Repository**
\`\`\`bash
git clone https://github.com/galkamay/aws-lambda-project.git
cd aws-lambda-project
\`\`\`

#### **Step 2: Package the Lambda Function**
Navigate to the `lambda_function` directory:
\`\`\`bash
cd lambda_function
Compress-Archive -Path app.py -DestinationPath function.zip
\`\`\`

#### **Step 3: Deploy Infrastructure**
Navigate to the Terraform directory:
\`\`\`bash
cd ../terraform
terraform init
terraform apply
\`\`\`

#### **Step 4: Retrieve API Gateway URL**
After deployment, retrieve the API URL using:
\`\`\`bash
terraform output
\`\`\`
The URL will look like:
\`\`\`plaintext
https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/sum
\`\`\`

---

### **4. Using the API**

#### **Sending a Valid Request**
\`\`\`bash
curl -X POST -d '{"number1": 5, "number2": 10}' -H "Content-Type: application/json" https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/sum
\`\`\`

**Expected Response:**
\`\`\`json
{
    "result": 15
}
\`\`\`

#### **Handling Invalid Requests**
1. **Missing keys:**
   \`\`\`bash
   curl -X POST -d '{"number1": 5}' -H "Content-Type: application/json" https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/sum
   \`\`\`

   **Response:**
   \`\`\`json
   {
       "error": "ValidationError",
       "message": "Missing key: 'number1' and/or 'number2'"
   }
   \`\`\`

2. **Invalid values:**
   \`\`\`bash
   curl -X POST -d '{"number1": "abc", "number2": 10}' -H "Content-Type: application/json" https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/sum
   \`\`\`

   **Response:**
   \`\`\`json
   {
       "error": "ValidationError",
       "message": "Invalid value: 'number1' and 'number2' must be integers."
   }
   \`\`\`

---

### **5. Verifying SNS Notifications**
- Subscribe to the SNS topic using your email:
  \`\`\`bash
  aws sns subscribe --topic-arn <sns-topic-arn> --protocol email --notification-endpoint <your-email>
  \`\`\`
- Confirm the subscription from your email inbox.
- Trigger the Lambda function with valid input and check your email for the notification.

---

### **6. Monitoring**
View logs in AWS CloudWatch:
\`\`\`bash
aws logs describe-log-streams --log-group-name /aws/lambda/SumFunction
aws logs get-log-events --log-group-name /aws/lambda/SumFunction --log-stream-name <log-stream-name>
\`\`\`

---

### **7. Cleanup**
To avoid incurring costs, destroy the infrastructure:
\`\`\`bash
terraform destroy
\`\`\`

---

## **Future Enhancements**
- Add support for additional operations (e.g., subtraction, multiplication).
- Integrate with a database for storing calculation history.
- Add authentication to the API Gateway.

---

## **AWS CLI and Terraform Commands**

Here are some additional AWS CLI and Terraform commands you can use:

### **1. Add a subscription to SNS Topic**
```bash
aws sns subscribe --topic-arn <sns-topic-arn> --protocol email --notification-endpoint <your-email>
```

### **2. Check existing subscriptions**
```bash
aws sns list-subscriptions-by-topic --topic-arn <sns-topic-arn>
```

### **3. Send a request via API Gateway**
```bash
curl -X POST -d '{"number1": 5, "number2": 10}' -H "Content-Type: application/json" https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/sum
```

### **4. Check logs in CloudWatch**
```bash
aws logs describe-log-streams --log-group-name /aws/lambda/SumFunction
aws logs get-log-events --log-group-name /aws/lambda/SumFunction --log-stream-name <log-stream-name>
```

### **5. Destroy resources**
```bash
terraform destroy
```
