# AWS Provider-Konfiguration
provider "aws" {
  region = "eu-central-1"  # Passen Sie die Region an Ihre Bedürfnisse an
}

# Globale Variable für die Umgebung (z.B. dev, staging, prod)
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# SNS Topic für CloudWatch Alarme (optional, aber empfohlen)
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}_alerts_topic"
}

# IAM-Konfiguration
module "iam" {
  source = "./009_iam.tf"  # Verweis auf die IAM-Datei im selben Verzeichnis
  environment = var.environment
}

# CloudWatch-Konfiguration
module "cloudwatch" {
  source = "./007_cloudwatch.tf"
  environment = var.environment
  alarm_actions = [aws_sns_topic.alerts.arn]
}

# Application Load Balancer
module "alb" {
  source = "./005_application_Loadbalancer.tf"
  environment = var.environment
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  security_group_id = var.alb_security_group_id
}

# Autoscaling
module "autoscaling" {
  source = "./004_autoscaling.tf"
  environment = var.environment
  image_id = var.image_id
  instance_type = var.instance_type
  subnet_ids = var.subnet_ids
  subnet_id = var.subnet_id
  security_group_id = var.ec2_security_group_id
  iam_instance_profile = module.iam.iam_instance_profile_name
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  target_group_arn = module.alb.alb_target_group_arn
}

# API Gateway
module "api_gateway" {
  source = "./006_api_gateway.tf"
  environment = var.environment
  stage_name = var.stage_name
  backend_url = module.alb.alb_dns_name
}

# RDS-Datenbank
module "rds" {
  source = "./010_rds_mysql.tf"
  environment = var.environment
  db_instance_class = var.db_instance_class
  allocated_storage = var.allocated_storage
  engine = var.engine
  engine_version = var.engine_version
  username = var.db_username
  password = var.db_password
  publicly_accessible = false
  vpc_security_group_ids = [var.rds_security_group_id]
  subnet_group_name = var.rds_subnet_group_name
}

# S3-Bucket
module "s3" {
  source = "./011_s3_cloudfront.tf"
  environment = var.environment
  bucket_name = "${var.environment}-bucket"
}

# Cognito
module "cognito" {
  source = "./008_cognito.tf"
  environment = var.environment
  callback_urls = var.cognito_callback_urls
  logout_urls = var.cognito_logout_urls
}

# Konsolidierte Outputs, um nützliche Informationen aus den Modulen zu sammeln
output "iam_role_arn" {
  description = "ARN der IAM-Rolle"
  value = module.iam.iam_role_arn
}

output "cloudwatch_high_cpu_alarm_arn" {
  description = "ARN des CloudWatch CPU Alarms"
  value = module.cloudwatch.high_cpu_alarm_arn
}

output "alb_dns_name" {
  description = "DNS Name des Application Load Balancers"
  value = module.alb.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name der Autoscaling Gruppe"
  value = module.autoscaling.autoscaling_group_name
}

output "api_gateway_endpoint" {
  description = "Endpoint des API Gateway"
  value = module.api_gateway.api_endpoint
}

output "rds_endpoint" {
  description = "Endpoint der RDS-Datenbank"
  value = module.rds.endpoint
}

output "s3_bucket_name" {
  description = "Name des S3 Buckets"
  value = module.s3.bucket_name
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value = module.cognito.user_pool_client_id
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value = module.cloudfront.cloudfront_domain_name
}
