# rds_mysql/main.tf

# RDS MySQL Database Instance
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  max_allocated_storage = 100       # Optional: Enable autoscaling of storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  # Multi-AZ deployment for high availability (optional)
  # multi_az = true

  backup_retention_period = 7  # Keeps automated backups for 7 days
  backup_window           = "07:00-09:00"

  # Optional: Enable encryption at rest
  # storage_encrypted = true
  # kms_key_id = var.kms_key_id

  # VPC Security Group to restrict access
  vpc_security_group_ids = [aws_security_group.db_access_sg.id]

  tags = {
    Name        = "MySQLDatabase"
    Environment = var.environment
  }
}

# Security Group for RDS MySQL
resource "aws_security_group" "db_access_sg" {
  name        = "${var.environment}_db_access_sg"
  description = "Allow MySQL access only from the backend"
  vpc_id      = var.vpc_id

  # Allow MySQL access (port 3306) from EC2 instances in the backend
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.backend_cidr_blocks
  }

  # Outbound rules (all traffic allowed by default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "RDSAccessSG"
    Environment = var.environment
  }
}
