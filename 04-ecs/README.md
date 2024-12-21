# Terraform Configuration Summary

## AWS Provider Configuration
- **Provider Block**: Sets up communication with AWS using the `aws` provider.
- **Region**: Defaulted to `us-east-2` (Ohio). Modify as needed for your deployment.

---

## Identity and Access Management (IAM) Roles and Policies

### IAM Roles
- `ecs_task_execution`: Allows ECS tasks to perform actions like pulling container images and logging.
- `ecs_task_role`: Grants ECS tasks permissions to interact with AWS services.
- `ecs_ec2_role`: Allows EC2 instances to act as ECS nodes.

### IAM Policies
- `ecs_task_execution_policy`: Grants ECS tasks access to ECR and CloudWatch logs.
- `dynamodb_policy`: Grants ECS tasks permissions to interact with DynamoDB.
- `ecs_node_policy`: Grants ECS nodes permissions to interact with ECS, ECR, and CloudWatch logs.

### Policy Attachments
- Attaches appropriate policies to their respective roles for ECS tasks and nodes.

---

## Elastic Load Balancer (ALB)

### Application Load Balancer
- **Name**: `ecs-alb`
- **Traffic Type**: Supports HTTP traffic and balances across ECS tasks.

### Target Group
- **Name**: `ecs-tg`
- **Configuration**:
  - Protocol: HTTP
  - Port: 8000
  - Health Check Path: `/gtg`

---

## ECS Cluster, Tasks, and Services

### ECS Cluster
- **Name**: `ecs-cluster`
- **Purpose**: Hosts ECS tasks and services.

### ECS Task Definition
- **Family**: `flask-app`
- **Container Details**:
  - CPU: 256
  - Memory: 256
  - Port: 8000
- **IAM Roles**:
  - Execution Role: Manages task execution.
  - Task Role: Grants permissions for service interaction.

### ECS Service
- **Name**: `flask-service`
- **Configuration**:
  - Desired Count: 2 tasks.
  - Load Balancer: Integrated for traffic distribution.

---

## Compute Resources

### Launch Template
- **Name**: `ecs-launch-template`
- **Configuration**:
  - AMI: `ami-0e3b2096ff08f7b38`
  - Instance Type: `t2.micro`
  - Instance Profile: `ecs_instance_profile`
  - Security Groups: Flask and SSH access.

### Auto Scaling Group
- **Name**: `ecs-cluster-asg`
- **Details**:
  - Desired Capacity: 2 instances.
  - Tags: Instances tagged as `Name: ecs-asg-instance`.

---

## Network Configuration
- **Subnets**: Resources span two subnets for high availability.
- **Security Groups**: Pre-existing security groups used for HTTP and SSH access.

---

## Key Features and Notes
- **Health Checks**: Configured for the ALB to monitor ECS tasks' health.
- **Encryption**: Root EBS volume is encrypted for security.
- **IAM Best Practices**: Policies scoped to required actions to minimize over-permissioning.

---

This configuration establishes a robust ECS environment for running containerized applications on AWS EC2 with load balancing, autoscaling, and secure role-based access.
