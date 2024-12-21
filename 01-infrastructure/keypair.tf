# Key Pair for Secure EC2 Instance Access
resource "aws_key_pair" "challenge-key" {
  key_name   = "challenge-key"                   # Name of the key pair in AWS
  public_key = file("./keys/EC2_key_public")     # Path to the public key file for SSH access
}

