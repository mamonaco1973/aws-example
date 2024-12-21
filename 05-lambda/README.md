# Terraform Files Summary

## **api.tf**
This file configures an **API Gateway (v2)** with various resources:

### **1. API Definition**
- Creates an HTTP-based API Gateway named `flask-api`.

### **2. Stages**
- Defines a default stage (`$default`) with auto-deployment enabled.

### **3. Routes**
- Sets up routes for API endpoints:
  - **POST /candidate/{name}**
  - **GET /candidate/{name}**
  - **GET /candidates**
  - **GET /gtg**
- These routes are mapped to specific integrations with AWS Lambda functions.

### **4. Integrations**
- Links the API routes to Lambda functions (`AWS_PROXY` integrations):
  - **flask_candidate_post**
  - **flask_candidate_get**
  - **flask_candidates_get**
  - **flask_gtg**
- Includes request parameters like query strings and paths.

### **5. Permissions**
- Grants API Gateway permissions to invoke the Lambda functions for all the configured routes.

---

## **lambdas.tf**
This file defines the **AWS Lambda functions**:

### **1. Lambda Functions**
- **flask_gtg**: Health-check handler for the `/gtg` route.
- **flask_candidate_get**: Retrieves candidate data for `/candidate/{name}`.
- **flask_candidate_post**: Adds or updates candidate data for `/candidate/{name}`.
- **flask_candidates_get**: Fetches all candidates for `/candidates`.

### **2. Configuration**
- Specifies the runtime as Python 3.13.
- Associates the Lambda functions with a pre-configured IAM role (`lambda_role`).
- Sets the handler and filename for each function (assuming the code is pre-zipped).

---

## **roles.tf**
This file defines the **IAM role and permissions** for the Lambda functions:

### **1. IAM Role**
- Creates a role (`flask-gtg-role`) with trust relationships to allow Lambda execution.

### **2. IAM Policy**
- Attaches a policy (`flask-gtg-policy`) to the role with permissions to:
  - Query, scan, and put items in a DynamoDB table named `Candidates`.

### **3. DynamoDB Table**
- Uses a data source to reference the `Candidates` table, granting required permissions to the Lambda functions.

---

## **Overall Functionality**
These files together:
- Deploy an HTTP API Gateway to expose several endpoints.
- Link these endpoints to Lambda functions that interact with a DynamoDB table (`Candidates`) for data operations.
- Secure the setup using an IAM role and policy granting minimal necessary permissions.
