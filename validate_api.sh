#!/bin/bash

# Configuration

API_ID=$(aws apigatewayv2 get-apis --query "Items[?Name=='flask-api'].{id:ApiId}" --output text)        
SERVICE_URL="https://${API_ID}.execute-api.us-east-2.amazonaws.com"

cd ./02-packer/scripts # Navigate to the test scripts directory.
echo "NOTE: Testing the API Gateway Solution."
echo "NOTE: URL for API Solution is $SERVICE_URL/gtg?details=true"
./test_candidates.py $SERVICE_URL 

cd ..
cd ..
