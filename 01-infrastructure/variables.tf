# Number of instances to deploy in the autoscaling group
# This variable defines the number of EC2 instances to be deployed within the Auto Scaling Group.
# Adjust this value as necessary to meet the desired scalability and workload requirements.
variable "asg_instances" {
  default = 2 # Default is set to 2 instances for a basic fault-tolerant deployment.
}

# The AMI (Amazon Machine Image) to use in the launch template attached to the autoscaling group.

variable "default_ami" {
  default = "ami-0c80e2b6ccb9ad6d1" # Replace with your own AMI ID for customized deployments.
}
