# # Configure Terraform Backend for State Management
# terraform {
#   backend "s3" {
#     bucket         = "824622998597-tfstate"       # S3 bucket for storing the Terraform state file
#     key            = "lambda.tfstate"            # Path within the S3 bucket for the state file
#     region         = "us-east-2"                 # Region of the S3 bucket
#     dynamodb_table = "824622998597-tf-lock-table" # DynamoDB table for state locking
#   }
# }
