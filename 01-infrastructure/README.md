## Terraform Infrastructure Summary

This project contains the Terraform configuration for the infrastructure deployed in the solution.

### [alb.tf](./alb.tf)

- **Application Load Balancer (ALB)**:
  - Creates a public-facing ALB named `challenge-alb` on **port 80**.
  - Distributes incoming HTTP traffic across multiple targets.

  - **Target Group**:
    - Creates a Target Group named `challenge-alb-tg` to group targets listening on **port 8000**.
    - Includes health checks with a health check path `/gtg` to ensure targets are operational.

  - **HTTP Listener**:
    - Configures an HTTP listener on the ALB to listen on **port 80**.
    - Forwards incoming requests to the `challenge-alb-tg` target group.

### [asg.tf](./asg.tf)

- **Auto Scaling Group (ASG)**:
  - Creates an Auto Scaling Group named `challenge-flask-asg`:
    - Uses a launch template for EC2 instance configuration.
    - Specifies subnets for deployment across multiple availability zones.
    - Configures scaling parameters:
      - **Desired capacity**: `var.asg_instances`.
      - **Minimum capacity**: `var.asg_instances`.
      - **Maximum capacity**: 4.
    - Monitors instance health using **ELB health checks**.
    - Attaches instances to an **ALB target group** for load balancing.
    - Includes instance tagging for organization.

- **Scaling Policies**:
  - **Scale Up Policy**:
    - Increases instance count by **1** when triggered.
    - Uses a cooldown period of **120 seconds** between scaling actions.
  - **Scale Down Policy**:
    - Decreases instance count by **1** when triggered.
    - Uses a cooldown period of **120 seconds** between scaling actions.

- **CloudWatch Alarms**:
  - **High CPU Utilization Alarm**:
    - Monitors **CPUUtilization > 80%** for **2 consecutive minutes**.
    - Triggers the **scale-up policy** when breached.
  - **Low CPU Utilization Alarm**:
    - Monitors **CPUUtilization < 5%** for **2 consecutive minutes**.
    - Triggers the **scale-down policy** when breached.

### [backend.tf](./backend.tf)

Remote State Configuration

  - **Backend Storage**:
    - Configures Terraform to use an **Amazon S3 bucket** for state file storage:
      - **Bucket Name**: `824622998597-tfstate`.
      - **State File Path**: `main.tfstate` (key for organizing the state file).
      - **Region**: `us-east-2` (must match the region of the S3 bucket).

  - **State Locking**:
    - Utilizes a **DynamoDB table** for state locking:
      - **Table Name**: `824622998597-tf-lock-table`.
      - Prevents simultaneous modifications to the Terraform state, ensuring consistency.

### [dynamo.tf](./dynamo.tf)

Creates DynamoDB Table Needed by the Flask Application
  - **Table Details**:
    - Creates a DynamoDB table named **`Candidates`**:
    - Uses **PAY_PER_REQUEST** billing mode, which adjusts costs based on usage.
    - Sets **CandidateName** as the **partition key (hash key)** to uniquely identify items.

  - **Attributes**:
    - Defines the **CandidateName** attribute:
      - Type: **String (S)**.

### [ec2.tf](./ec2.tf)

Creates Launch Templates for Application Deployment

  - **IAM Instance Profile**:
    - Creates an **IAM instance profile** named `ec2_instance_profile`.
    - Attaches an IAM role (`challenge_ec2_role`) to provide permissions for EC2 instances.

  - **Launch Template**:
    - Defines a **Launch Template** named `challenge_launch_template`:
      - Configures root volume:
        - **Size**: 8 GiB.
        - **Type**: `gp3` (high performance and cost-effective).
        - **Encrypted**: Enabled.
      - Automatically deletes upon instance termination.
      - Sets **instance type** to `t2.micro` (low-cost, general-purpose).
      - Uses a **dynamic AMI ID** (`var.default_ami`) for instance flexibility.
      - Includes **network configurations**:
        - Assigns a public IP for internet access.
        - Attaches security groups:
          - **SSH Access**: `challenge_sg_ssh`.
          - **Flask Application Access**: `challenge_sg_flask`.
      - Attaches the IAM instance profile for role-based access.
      - Encodes and includes a **bootstrap script** (`bootstrap.sh`) for instance initialization.
      - Tags instances as **`challenge-lt-instance`** for identification.

### [keypair.tf](./keypair.tf)

- Creates access key  `challenge-key` for SSH access to the EC2 instances. [The private key can be found here](./keys/EC2_key_private) if you need to SSH to any of the instances.

### [networking.tf](./networking.tf)

Creates VPC and Public Subnets

  - **Virtual Private Cloud (VPC)**:
    - Creates a **VPC** named `challenge-vpc`:
      - **CIDR Block**: `10.0.0.0/24`.
      - **DNS Support**: Enabled.

  - **Internet Gateway (IGW)**:
    - Creates an **Internet Gateway** named `challenge-igw`:
      - Associates it with `challenge-vpc`.

  - **Route Table**:
    - Configures a **public route table** named `public-route-table`:
      - Adds a default route for all IPv4 traffic (`0.0.0.0/0`) via the Internet Gateway.

  - **Subnets**:
    - **Subnet 1** (`challenge-subnet-1`):
      - **CIDR Block**: `10.0.0.0/26`.
      - **Availability Zone**: `us-east-2a`.
      - **Public IP Mapping**: Enabled.
    - **Subnet 2** (`challenge-subnet-2`):
      - **CIDR Block**: `10.0.0.64/26`.
      - **Availability Zone**: `us-east-2b`.
      - **Public IP Mapping**: Enabled.

  - **Route Table Associations**:
    - Associates the **public route table** with both public subnets:
      - **Subnet 1**: `challenge-subnet-1`.
      - **Subnet 2**: `challenge-subnet-2`.

  - **DynamoDB Gateway VPC Endpoint**:
    - Configures a **VPC Endpoint** for **DynamoDB**:
      - Type: **Gateway**.
      - Associates the endpoint with `challenge-vpc` and attaches it to the public route table.
      - Includes an optional IAM policy for internal-only DynamoDB access.

### [outputs.tf](./outputs.tf)

- Outputs the public load-balancer DNS to access the solution.

### [roles.tf](./roles.tf)

Creates Roles and Policies for DynamoDB Access.

  - **IAM Role for EC2**:
    - Creates an **IAM Role** named `challenge_ec2_role`.
    - Allows EC2 instances to assume the role using an **assume role policy**.

  - **IAM Policy for DynamoDB Access**:
    - Defines a **policy** named `challenge_access_policy`.
    - Grants specific DynamoDB table permissions:
      - `dynamodb:Query`, `dynamodb:PutItem`, `dynamodb:Scan`.
    - Restricts permissions to the **`Candidates` DynamoDB table**.

  - **Policy Attachment**:
    - Attaches the policy to the IAM role.

### [security.tf](./security.tf)

Creates Security Groups

  - **Security Group for SSH Access**:
    - **Name**: `challenge-sg-ssh`
    - Allows inbound SSH traffic (port 22).
    - Allows unrestricted outbound traffic.

  - **Security Group for HTTP Access**:
    - **Name**: `challenge-sg-http`
    - Allows inbound HTTP traffic (port 80).
    - Allows unrestricted outbound traffic.

  - **Security Group for Flask Application Traffic**:
    - **Name**: `challenge-sg-flask`
    - Allows inbound Flask application traffic (port 8000).
    - Allows unrestricted outbound traffic.

### [variables.tf](./variables.tf)

- **Defines Terraform Variables**:
  - **Auto Scaling Group Instance Count**:
    - Variable: `asg_instances`.
    - Default: `2` (provides fault tolerance).
  - **Default Amazon Machine Image (AMI)**:
    - Variable: `default_ami`.
    - Default: `ami-0c80e2b6ccb9ad6d1`.
