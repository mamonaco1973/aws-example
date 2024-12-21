#!/bin/bash

# Fourth phase - Run the docker build

cd 03-docker
echo "NOTE: Building flask container with Docker."

# Retrieve the AWS Account ID using the AWS CLI.
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Authenticate Docker to AWS ECR using the retrieved credentials.
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com

# Build and push the Docker image.
# The image tag includes the AWS Account ID and the specified repository and tag.

docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com/flask-app:flask-app-rc1 . --push

cd ..
