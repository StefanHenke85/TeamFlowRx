# IAM Role for EC2 instances (General)
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

# IAM Policy for CloudWatch Logs (Attached to EC2 Role)
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.environment}_cloudwatch_logs_policy"
  description = "Allow EC2 instances to send logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach CloudWatch Logs Policy to the EC2 Role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}_ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Role for RDS Access (Optional, if RDS access is required)
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

# Example EC2 Instance using the IAM Instance Profile
resource "aws_instance" "backend_server" {
  ami                         = "ami-0c55b159cbfafe1f0" # Beispiel-AMI
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true

  tags = {
    Name        = "${var.environment}_backend_server"
    Environment = var.environment
  }
}

# Tags and Environment-Specific Configuration
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}
