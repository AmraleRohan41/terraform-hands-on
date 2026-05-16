
# Create an EC2 instance

# Create a key pair for SSH access
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# Create a default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create a security group for the VPC
resource "aws_security_group" "my_sg" {
    name = "automated-sg"
    description = "Security group for automated EC2 instance"
    vpc_id = aws_default_vpc.default.id  #Iterpolation to get the VPC ID from the default VPC resource

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

   ingress {
    protocol  = "tcp"
    self      = true
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = var.ec2_ami_id # Ubuntu 20.04 LTS AMI (HVM), SSD Volume Type
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.my_key.key_name # Reference the key pair created above
  security_groups = [aws_security_group.my_sg.name] # Reference the security group created above

  user_data = file("install-nginx.sh") # Reference the user data script to install nginx
  
  root_block_device {
   volume_size = var.ec2_root_storage_size
   volume_type = "gp2"
  }
    
    tags = {
        Name = "My EC2 Instance"
    }
}