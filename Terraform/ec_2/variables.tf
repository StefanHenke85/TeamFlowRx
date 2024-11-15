# ec2/variables.tf

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "key_pair_name" {
  description = "The key pair name for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "The CIDR blocks allowed to access the EC2 instance via SSH"
  type        = list(string)
}
