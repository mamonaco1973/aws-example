# The purpose of this module is to create the objects necessary to have a 
# remote state for terraform builds.check
  
# Configure the AWS provider
provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tfstate" {
  bucket = "${data.aws_caller_identity.current.account_id}-tfstate"
}

resource "aws_dynamodb_table" "terraform_lock_table" {
  name           = "${data.aws_caller_identity.current.account_id}-tf-lock-table"
  billing_mode   = "PAY_PER_REQUEST" # Change to PROVISIONED if needed
  hash_key       = "LockID"          # Primary key for the table

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "TerraformState"
    ManagedBy   = "Terraform"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
}
