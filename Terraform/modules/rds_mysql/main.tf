# RDS MySQL Database Instance with Multi-AZ
resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = true  # Activates Multi-AZ Deployment

  backup_retention_period = 7
  backup_window           = "07:00-09:00"

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

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.backend_cidr_blocks
  }

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
