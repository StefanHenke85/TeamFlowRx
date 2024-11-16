output "rds_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = aws_db_instance.mysql_db.endpoint
}

output "rds_security_group_id" {
  description = "The ID of the security group for RDS MySQL"
  value       = aws_security_group.db_access_sg.id
}
