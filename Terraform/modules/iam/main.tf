# IAM Rolle für EC2-Instanzen, damit sie CloudWatch Logs senden können
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.environment}_ec2_cloudwatch_role"

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
}

# Richtlinie, die Berechtigungen für das Senden von Logs an CloudWatch gewährt
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

# Verknüpfung der CloudWatch Logs Policy mit der IAM-Rolle
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# IAM Instance Profile, das die IAM-Rolle der EC2-Instanz zuordnet
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}_ec2_instance_profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}

# Beispiel für eine EC2-Instanz, die das Instance Profile verwendet
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
