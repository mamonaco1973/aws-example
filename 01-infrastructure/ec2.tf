# EC2 Instances and Launch Template for Load Balancer Integration

# Instance Profile for attaching the IAM Role to EC2 instances
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"                  # Name of the instance profile
  role = aws_iam_role.challenge_ec2_role.name    # Associated IAM role
}

# Uncommented Instance Definitions (Disabled Code):
# The following blocks can be uncommented if you need to create EC2 instances manually.

# # First EC2 instance
# resource "aws_instance" "challenge_instance_1" {
#   ami                          = "ami-0c80e2b6ccb9ad6d1"          # AMI ID
#   key_name                     = "challenge-key"                  # SSH key pair
#   instance_type                = "t2.micro"                       # Instance type
#   subnet_id                    = aws_subnet.challenge-subnet-1.id # Subnet ID
#   associate_public_ip_address  = true                             # Assign public IP
#   vpc_security_group_ids       = [                                # Security groups
#     aws_security_group.challenge_sg_ssh.id,
#     aws_security_group.challenge_sg_flask.id
#   ]
#   iam_instance_profile         = aws_iam_instance_profile.ec2_instance_profile.name
#   user_data                    = file("./scripts/bootstrap.sh")   # Bootstrap script
#   tags = { Name = "instance-1" }                                  # Tag for identification
# }
# 
# # Attach the first instance to the load balancer target group
# resource "aws_lb_target_group_attachment" "challenge_instance_1" {
#   target_group_arn = aws_lb_target_group.challenge_alb_tg.arn     # Target group ARN
#   target_id        = aws_instance.challenge_instance_1.id         # Instance ID
#   port             = 8000                                        # Port
# }

# # Second EC2 instance
# resource "aws_instance" "challenge_instance_2" {
#   ami                          = "ami-0c80e2b6ccb9ad6d1"          # AMI ID
#   key_name                     = "challenge-key"                  # SSH key pair
#   instance_type                = "t2.micro"                       # Instance type
#   subnet_id                    = aws_subnet.challenge-subnet-2.id # Subnet ID
#   associate_public_ip_address  = true                             # Assign public IP
#   vpc_security_group_ids       = [                                # Security groups
#     aws_security_group.challenge_sg_ssh.id,
#     aws_security_group.challenge_sg_flask.id
#   ]
#   iam_instance_profile         = aws_iam_instance_profile.ec2_instance_profile.name
#   user_data                    = file("./scripts/bootstrap.sh")   # Bootstrap script
#   tags = { Name = "instance-2" }                                  # Tag for identification
# }
# 
# # Attach the second instance to the load balancer target group
# resource "aws_lb_target_group_attachment" "challenge_instance_2" {
#   target_group_arn = aws_lb_target_group.challenge_alb_tg.arn     # Target group ARN
#   target_id        = aws_instance.challenge_instance_2.id         # Instance ID
#   port             = 8000                                        # Port
# }

# Data Source to dynamically fetch AMI by name (if needed)
# data "aws_ami" "flask_server" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["flask_server_ami*"]            # AMI name pattern
#   }
#   owners = ["self"]                           # Owned by current AWS account
# }

# Launch Template for Autoscaling Group
resource "aws_launch_template" "challenge_launch_template" {
  name        = "challenge_launch_template"      # Launch template name
  description = "Launch template for autoscaling"

  # Root volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"                    # Root device name

    ebs {
      delete_on_termination = true               # Delete volume on instance termination
      volume_size           = 8                  # Volume size (GiB)
      volume_type           = "gp3"              # Volume type
      encrypted             = true               # Enable encryption
    }
  }

  # Network settings
  network_interfaces {
    associate_public_ip_address = true           # Assign public IP
    delete_on_termination       = true           # Delete interface on instance termination
    security_groups             = [              # Security groups for network access
      aws_security_group.challenge_sg_https.id,
      aws_security_group.challenge_sg_flask.id
    ]
  }

  # IAM instance profile
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  # Instance details
  instance_type = "t2.micro"                     # Instance type
  #key_name      = "challenge-key"               # SSH key pair
  image_id      = var.default_ami                # AMI ID (using variable for flexibility)

  # Bootstrap script
  user_data = base64encode(file("./scripts/bootstrap.sh"))

  # Tag specifications
  tag_specifications {
    resource_type = "instance"                   # Tag for EC2 instances
    tags = {
      Name = "challenge-lt-instance"            # Tag name
    }
  }
}
