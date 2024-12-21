# Define an output variable to expose the DNS name of the Application Load Balancer (ALB) running ECS
output "ecs_dns_name" {
  # The value to be output is the DNS name of the ALB resource
  value = aws_lb.ecs_lb.dns_name
}
