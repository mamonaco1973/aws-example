# # Configure Terraform backend for state management
# terraform {
#   backend "s3" {
#     bucket         = "824622998597-tfstate"       # S3 bucket to store the Terraform state file
#     key            = "main.tfstate"              # Path to the state file within the S3 bucket
#     region         = "us-east-2"                 # AWS region of the S3 bucket
#     dynamodb_table = "824622998597-tf-lock-table" # DynamoDB table for state locking
#   }
# }
