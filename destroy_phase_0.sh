#!/bin/bash

cd 05-lambda
terraform init
terraform destroy -auto-approve
cd ..

cd 04-ecs
terraform init
terraform destroy -auto-approve
cd ..
