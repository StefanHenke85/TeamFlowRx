# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}_ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Role for RDS Access
resource "aws_iam_role" "rds_role" {
  name = "${var.environment}_rds_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

output "iam_role_arn" {
  description = "IAM Role ARN for EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "iam_instance_profile_name" {
  description = "IAM Instance Profile for EC2"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
