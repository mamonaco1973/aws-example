#!/bin/bash

# Sixth phase - Deploy API/Lambda version

cd 05-lambda
echo "NOTE: Zipping lambda code into lambda.zip"

cd code
rm -f -r lambdas.zip
zip lambdas.zip *.py
cd ..

echo "NOTE: Building API/Lambda Version in phase 6."

terraform init
terraform apply -auto-approve
cd ..
