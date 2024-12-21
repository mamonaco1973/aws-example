# -----------------------------------------------------------------------------
# DATA BLOCK: AWS VPC
# -----------------------------------------------------------------------------
# Retrieves information about an existing AWS VPC using a tag filter.
# The VPC must already exist in the AWS account and region targeted by Terraform.
# This is useful for referencing the VPC in other resources without hardcoding its ID.
data "aws_vpc" "challenge_vpc" {
  # FILTER: Define the criteria for selecting the VPC.
  filter {
    name = "tag:Name"          # Use the "Name" tag to identify the VPC.
    values = ["challenge-vpc"] # Match the tag value for the desired VPC.

    # NOTE:
    # - Ensure that the tag value "challenge-vpc" uniquely identifies the VPC.
    # - If multiple VPCs match this filter, results may be inconsistent.
  }
}

# -----------------------------------------------------------------------------
# DATA BLOCK: AWS SUBNET 1
# -----------------------------------------------------------------------------
# Retrieves information about a specific subnet in the VPC, identified by its "Name" tag.
# This is typically used to associate resources like EC2 instances or load balancers
# with a particular subnet.
data "aws_subnet" "challenge_subnet_1" {
  # FILTER: Criteria for selecting the subnet.
  filter {
    name = "tag:Name"                  # Use the "Name" tag to identify the subnet.
    values = ["challenge-subnet-1"]   # Match the tag value for the desired subnet.

    # NOTE:
    # - Ensure "challenge-subnet-1" is a unique tag value to avoid conflicts.
    # - The subnet must already exist in the targeted VPC and region.
  }
}

# -----------------------------------------------------------------------------
# DATA BLOCK: AWS SUBNET 2
# -----------------------------------------------------------------------------
# Retrieves information about another specific subnet in the VPC, also identified by its "Name" tag.
# This is often used for multi-AZ deployments, associating resources with different availability zones.
data "aws_subnet" "challenge_subnet_2" {
  # FILTER: Define the criteria for selecting the subnet.
  filter {
    name = "tag:Name"                  # Use the "Name" tag to identify the subnet.
    values = ["challenge-subnet-2"]   # Match the tag value for the desired subnet.

    # NOTE:
    # - "challenge-subnet-2" should uniquely identify the target subnet.
    # - Ensure proper tagging to avoid ambiguity.
  }
}

# -----------------------------------------------------------------------------
# DATA BLOCK: Security Group for Flask
# -----------------------------------------------------------------------------
# Retrieves information about the security group used for the Flask application.
# Security groups control network traffic to and from AWS resources.
data "aws_security_group" "challenge_sg_flask" {
  # FILTER: Search for the security group by its group name.
  filter {
    name   = "group-name"            # Filter by the security group's name.
    values = ["challenge-sg-flask"] # Match the group name for the desired security group.

    # NOTE:
    # - Ensure "challenge-sg-flask" uniquely identifies the security group.
    # - This security group should have the required ingress and egress rules for Flask.
  }
}

# -----------------------------------------------------------------------------
# DATA BLOCK: Security Group for HTTP Traffic
# -----------------------------------------------------------------------------
# Retrieves information about the security group used for managing HTTP traffic.
# This is likely attached to resources like load balancers.
data "aws_security_group" "challenge_sg_http" {
  # FILTER: Define the criteria for selecting the security group.
  filter {
    name   = "group-name"            # Search by the security group's name.
    values = ["challenge-sg-http"]  # Match the group name for the desired security group.

    # NOTE:
    # - Ensure "challenge-sg-http" uniquely identifies the target security group.
    # - This security group should allow HTTP traffic (port 80).
  }
}

# -----------------------------------------------------------------------------
# DATA BLOCK: Security Group for HTTPS Traffic
# -----------------------------------------------------------------------------
# Retrieves information about the security group used for managing HTTPS traffic.
# This is likely attached to resources like load balancers.
data "aws_security_group" "challenge_sg_https" {
  # FILTER: Define the criteria for selecting the security group.
  filter {
    name   = "group-name"            # Search by the security group's name.
    values = ["challenge-sg-https"]  # Match the group name for the desired security group.

    # NOTE:
    # - Ensure "challenge-sg-http" uniquely identifies the target security group.
    # - This security group should allow HTTP traffic (port 80).
  }
}


# -----------------------------------------------------------------------------
# DATA BLOCK: Security Group for SSH Access
# -----------------------------------------------------------------------------
# Retrieves information about the security group used for SSH access to EC2 instances.
# This security group should allow inbound SSH traffic on port 22.
data "aws_security_group" "challenge_sg_ssh" {
  # FILTER: Define the criteria for selecting the security group.
  filter {
    name   = "group-name"            # Search by the security group's name.
    values = ["challenge-sg-ssh"]   # Match the group name for the desired security group.

    # NOTE:
    # - Ensure "challenge-sg-ssh" uniquely identifies the security group.
    # - This security group should have rules allowing SSH access (e.g., port 22).
  }
}

# Data source to reference the existing DynamoDB table "Candidates"
data "aws_dynamodb_table" "candidate-table" {
  name = "Candidates" # Name of the DynamoDB table
}
