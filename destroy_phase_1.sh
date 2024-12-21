#!/bin/bash
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
#aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com
ECR_REPOSITORY_NAME="flask-app"
aws ecr delete-repository --repository-name $ECR_REPOSITORY_NAME --force