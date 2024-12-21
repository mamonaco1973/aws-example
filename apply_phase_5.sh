#!/bin/bash

# Fifth phase - Deploy ECS version of the solution

cd 04-ecs
echo "NOTE: Building ecs infrastructure phase 5."
terraform init
terraform apply -auto-approve
cd ..
