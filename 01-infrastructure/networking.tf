# Main VPC for the tech challenge
resource "aws_vpc" "challenge-vpc" {
  cidr_block           = "10.0.0.0/24"           # CIDR block for the VPC
  enable_dns_support   = true                    # Enable DNS resolution
  enable_dns_hostnames = true                    # Allow public DNS hostnames for instances
  tags = {
    Name = "challenge-vpc"                       # Tag for easy identification
  }
}

# Internet Gateway (IGW) for public subnet internet access
resource "aws_internet_gateway" "challenge-igw" {
  vpc_id = aws_vpc.challenge-vpc.id              # VPC to associate with the IGW
  tags = {
    Name = "challenge-igw"                       # Tag for easy identification
  }
}

# Route table for public internet traffic
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.challenge-vpc.id              # VPC to associate with the route table
  tags = {
    Name = "public-route-table"                  # Tag for easy identification
  }
}

# Default route for internet-bound traffic in the public route table
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id        # Public route table ID
  destination_cidr_block = "0.0.0.0/0"                      # Route all IPv4 traffic
  gateway_id             = aws_internet_gateway.challenge-igw.id # Internet gateway ID
}

# First public subnet within the VPC
resource "aws_subnet" "challenge-subnet-1" {
  vpc_id                  = aws_vpc.challenge-vpc.id        # VPC to associate with the subnet
  cidr_block              = "10.0.0.0/26"                   # CIDR block for the subnet
  map_public_ip_on_launch = true                            # Automatically assign public IPs
  availability_zone       = "us-east-2a"                    # Availability zone
  tags = {
    Name = "challenge-subnet-1"                             # Tag for easy identification
  }
}

# Second public subnet within the VPC
resource "aws_subnet" "challenge-subnet-2" {
  vpc_id                  = aws_vpc.challenge-vpc.id        # VPC to associate with the subnet
  cidr_block              = "10.0.0.64/26"                  # CIDR block for the subnet
  map_public_ip_on_launch = true                            # Automatically assign public IPs
  availability_zone       = "us-east-2b"                    # Availability zone
  tags = {
    Name = "challenge-subnet-2"                             # Tag for easy identification
  }
}

# Associate public route table with the first public subnet
resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.challenge-subnet-1.id         # Subnet ID
  route_table_id = aws_route_table.public.id                # Public route table ID
}

# Associate public route table with the second public subnet
resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.challenge-subnet-2.id         # Subnet ID
  route_table_id = aws_route_table.public.id                # Public route table ID
}

# DynamoDB Gateway VPC Endpoint for private access to DynamoDB
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.challenge-vpc.id              # VPC to associate with the endpoint
  service_name      = "com.amazonaws.us-east-2.dynamodb"    # DynamoDB service name
  vpc_endpoint_type = "Gateway"                             # Endpoint type: Gateway

  route_table_ids = [                                       # Attach endpoint to the public route table
    aws_route_table.public.id
  ]
}
