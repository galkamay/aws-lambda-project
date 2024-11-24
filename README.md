
# AWS Lambda API for Sum Calculation

This project demonstrates a serverless solution using AWS Lambda, API Gateway, and SNS. The API accepts two numbers as input, calculates their sum, and sends the result to an SNS topic. The system validates input data and handles errors gracefully.

---

## **Architecture**
The system has two key architectural setups:

1. **Infrastructure Management:**
   - Managed using **Terraform**.
   - Terraform provisions the following resources:
     - AWS Lambda (infrastructure only, code deployment managed by GitHub Actions after the first setup).
     - API Gateway for exposing the Lambda function.
     - SNS Topic for message delivery.
     - IAM Roles and Policies.

2. **Code Deployment:**
   - **GitHub Actions** handles:
     - Zipping and uploading the Lambda function code after the first setup.
     - Updating the deployed Lambda function without triggering Terraform.

---

## **Project Structure**

- **`.github/workflows`:**
  - Contains GitHub Actions workflows for building, testing, and deploying the Lambda function.
  
- **`terraform/`:**
  - Contains Terraform configurations for managing AWS infrastructure.

- **`lambda_function/`:**
  - Contains the source code for the Lambda function.

- **`README.md`:**
  - Documentation for the project.

---

## **Setup and Usage**

### Prerequisites
1. Install **Terraform**:
   - [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. Install **AWS CLI** and configure your credentials:
   ```bash
   aws configure
   ```

3. Clone the repository:
   ```bash
   git clone https://github.com/galkamay/aws-lambda-project.git
   cd aws-lambda-project-Main
   ```

---

### **Terraform Usage**

#### 1. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

#### 2. Create ZIP File Locally (Required for the First Apply Only):
   Compress the Lambda function code into a ZIP file:
   ```bash
   zip -r lambda_function/function.zip lambda_function/
   ```

#### 3. Apply Terraform Configuration:
   Provision the infrastructure:
   ```bash
   terraform apply
   ```
   This creates the following resources:
   - API Gateway
   - SNS Topic
   - Lambda function infrastructure (without code)

---

### **GitHub Actions Deployment**

GitHub Actions manages the deployment of the Lambda function code. The workflow includes:
1. **Zip the Lambda Function Code**.
2. **Deploy to AWS Lambda** using `aws lambda update-function-code`.

#### Setting Up GitHub Actions Runner Locally

If you need to run GitHub Actions locally:
1. Install the GitHub Actions Runner:
   - [GitHub Actions Runner Documentation](https://github.com/actions/runner)

2. Set up the runner:
   ```bash
   mkdir actions-runner && cd actions-runner
   curl -o actions-runner-linux-x64-2.308.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz
   tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz
   ./config.sh
   ```

3. Start the runner:
   ```bash
   ./run.sh
   ```

#### Triggering a GitHub Action Workflow
1. Push code changes to the `main` branch.
2. GitHub Actions automatically builds and deploys the Lambda function.

---

### **Manual Lambda Function Update**
In case you want to manually update the Lambda function code:
1. Zip the function code:
   ```bash
   zip -r function.zip lambda_function/
   ```

2. Update the Lambda function:
   ```bash
   aws lambda update-function-code --function-name SumFunction-dev --zip-file fileb://function.zip
   ```

---

### **Validation**
- **API Gateway**: Test the endpoint using Postman or `curl`.
- **SNS**: Confirm message delivery in the SNS topic.

---

## **Troubleshooting**

1. **Terraform Error: Function Already Exists**
   - If Terraform fails with a conflict error, ensure the function is not already created manually.
   - Use the following command to delete it:
     ```bash
     aws lambda delete-function --function-name SumFunction-dev
     ```

2. **GitHub Actions Runner Issues**
   - Verify the runner logs for errors.
   - Ensure AWS credentials are properly configured.

---

## **Contributing**

Contributions are welcome! Fork the repository and submit a pull request.

---


