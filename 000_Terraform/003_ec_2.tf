# Security Group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}_ec2_sg"
  description = "Allow inbound traffic to EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks  # SSH access restricted to specific IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "EC2SecurityGroup"
    Environment = var.environment
  }
}

# EC2 instance
resource "aws_instance" "backend_server" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_pair_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name        = "BackendServer"
    Environment = var.environment
  }
}
