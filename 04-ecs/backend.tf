# # -----------------------------------------------------------------------------
# # Configure Terraform Backend for State Management
# # -----------------------------------------------------------------------------
# terraform {
#   # Backend configuration to store the Terraform state file in Amazon S3
#   backend "s3" {
#     bucket         = "824622998597-tfstate"          # S3 bucket for storing the state file
#     key            = "ecs.tfstate"                  # Path within the bucket for the state file
#     region         = "us-east-2"                    # AWS region where the S3 bucket is located
#     dynamodb_table = "824622998597-tf-lock-table"   # DynamoDB table for state locking

#     # NOTES:
#     # - The S3 bucket must already exist in the specified region.
#     # - The DynamoDB table ensures state file locking to prevent simultaneous updates.
#     # - Ensure proper IAM permissions for Terraform to access both the S3 bucket
#     #   and the DynamoDB table.
#   }
# }
