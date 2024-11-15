# rds_mysql/outputs.tf

output "db_instance_id" {
  description = "The ID of the RDS MySQL database instance"
  value       = aws_db_instance.mysql_db.id
}

output "db_endpoint" {
  description = "The endpoint of the RDS MySQL database instance"
  value       = aws_db_instance.mysql_db.endpoint
}
