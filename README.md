
# AWS Lambda API for Sum Calculation

This project demonstrates a serverless solution using AWS Lambda, API Gateway, and SNS. The API accepts two numbers as input, calculates their sum, and sends the result to an SNS topic. The system validates input data and handles errors gracefully.

---

## **Architecture**
The system has two key architectural setups:

1. **Stage 1 Architecture:**
   - Invoke the Lambda function directly using AWS CLI or SDK.
   - The Lambda function computes the result and publishes it to an SNS topic.
   - Subscribers to the SNS topic (e.g., an email address) receive the result.

   ![Stage 1 Architecture](images/Screenshot%202024-11-22%20135508.png)

2. **Stage 2 Architecture:**
   - Expose the Lambda function via API Gateway.
   - The API Gateway receives HTTP POST requests and forwards them to the Lambda function.
   - The Lambda function computes the result, sends it to the SNS topic, and responds back to the client.

   ![Stage 2 Architecture](images/Screenshot%202024-11-22%20135526.png)

---

## **Step-by-Step Instructions**

### **1. Clone the Repository**
Clone the repository and navigate to the project directory:
```bash
git clone https://github.com/galkamay/aws-lambda-project.git
cd aws-lambda-project
```

---

### **2. Package the Lambda Function**
Navigate to the `lambda_function` directory and create a ZIP package of the Lambda code:
```bash
cd lambda_function
Compress-Archive -Path app.py -DestinationPath function.zip
```

---

### **3. Deploy Infrastructure**
Use Terraform to deploy the Lambda function, SNS topic, and API Gateway:
1. Navigate to the Terraform directory:
   ```bash
   cd ../terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

**Note:** After deployment, Terraform will output the following:
- API Gateway URL
- SNS Topic ARN
- Lambda Function Name

---

### **4. Subscribe to the SNS Topic**
Use the AWS CLI to subscribe your email to the SNS topic:
```bash
aws sns subscribe --topic-arn <sns-topic-arn> --protocol email --notification-endpoint <your-email>
```

**Confirm the subscription:** Check your email and click on the confirmation link.

---

### **5. Invoke the Lambda Function**

#### **Via AWS CLI:**
```bash
aws lambda invoke --function-name <lambda-function-name> --payload '{"number1": 5, "number2": 10}' output.json
```
**Check the output:**
```bash
cat output.json
```

---

#### **Via API Gateway:**
Use `curl` or PowerShell to send a POST request to the API Gateway endpoint:
```bash
curl -X POST -d '{"number1": 5, "number2": 10}' -H "Content-Type: application/json" <api-gateway-url>
```

**Expected Response:**
```json
{
    "result": 15
}
```

---

### **6. Handling Invalid Inputs**
Test the Lambda function with various invalid inputs to verify error handling:

#### **Missing Parameters:**
```bash
curl -X POST -d '{"number1": 5}' -H "Content-Type: application/json" <api-gateway-url>
```

**Response:**
```json
{
    "error": "ValidationError",
    "message": "Missing key: 'number1' and/or 'number2'"
}
```

#### **Invalid Data Types:**
```bash
curl -X POST -d '{"number1": "abc", "number2": 10}' -H "Content-Type: application/json" <api-gateway-url>
```

**Response:**
```json
{
    "error": "ValidationError",
    "message": "Invalid value: 'number1' and 'number2' must be integers."
}
```

---

### **7. Monitor Logs**
Use AWS CloudWatch to monitor the Lambda function logs:
1. Describe the log streams:
   ```bash
   aws logs describe-log-streams --log-group-name /aws/lambda/SumFunction
   ```
2. Retrieve log events:
   ```bash
   aws logs get-log-events --log-group-name /aws/lambda/SumFunction --log-stream-name <log-stream-name>
   ```

---

### **8. Cleanup Resources**
To avoid incurring costs, destroy the infrastructure when you're done:
```bash
terraform destroy
```

---

## **Future Enhancements**
- Add support for additional mathematical operations.
- Implement authentication for the API Gateway.
- Integrate with a database to log calculation history.

