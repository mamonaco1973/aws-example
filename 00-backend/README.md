## Terraform Remote State Module Summary

### **Purpose**
- This module creates the necessary bootstraping resources to support **remote state management** for Terraform builds.

### **AWS Provider**
- Configures the **AWS provider** to use the **`us-east-2` region**.

### **Resources Created**
1. **S3 Bucket for State Files**:
   - **Bucket Name**: Dynamically generated as `<AWS_ACCOUNT_ID>-tfstate`.
   - Stores the Terraform state files for remote state management.

2. **DynamoDB Table for State Locking**:
   - **Table Name**: Dynamically generated as `<AWS_ACCOUNT_ID>-tf-lock-table`.
   - **Billing Mode**: `PAY_PER_REQUEST` (adjustable to `PROVISIONED` if needed).
   - **Primary Key**: `LockID` (String).
   - **Tags**:
     - `Environment`: `TerraformState`.
     - `ManagedBy`: `Terraform`.

### **Outputs**
- **S3 Bucket Name**: Exposes the created S3 bucket name.
- **DynamoDB Table Name**: Exposes the created DynamoDB table name.

This setup ensures secure and efficient remote state management for Terraform deployments, with state locking to prevent conflicts.
