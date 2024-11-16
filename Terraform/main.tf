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

# Modul für IAM-Konfiguration
module "iam" {
  source      = "./modules/iam"
  environment = var.environment
}

# Modul für CloudWatch-Konfiguration
module "cloudwatch" {
  source        = "./modules/cloudwatch"
  environment   = var.environment
  alarm_actions = [aws_sns_topic.alerts.arn]  # Hier wird das SNS-Topic für Alarme verwendet
}

# Modul für Application Load Balancer
module "alb" {
  source            = "./modules/alb"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.security_groups.lb_sg_id
}

# Modul für Autoscaling
module "autoscaling" {
  source               = "./modules/autoscaling"
  environment          = var.environment
  image_id             = "ami-12345678"  # Beispiel-AMI
  instance_type        = "t3.micro"
  subnet_ids           = module.vpc.subnet_ids
  subnet_id            = module.vpc.subnet_ids[0]
  security_group_id    = module.security_groups.ec2_sg_id
  iam_instance_profile = module.iam.profile_name
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  target_group_arn     = module.alb.alb_target_group_arn
}

# Modul für API Gateway
module "api_gateway" {
  source        = "./modules/api_gateway"
  environment   = var.environment
  stage_name    = "dev"
  backend_url   = "http://${module.alb.alb_dns_name}" # Verbindung mit dem ALB
}

# Modul für RDS-Datenbank
module "rds" {
  source               = "./modules/rds"
  environment          = var.environment
  db_instance_class    = "db.t3.micro"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  username             = "admin"
  password             = "password123"  # Sicherstellen, dass dies sicher aufbewahrt wird
  publicly_accessible  = false
  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  subnet_group_name    = module.vpc.rds_subnet_group
}

# Modul für S3-Bucket
module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  bucket_name = "${var.environment}-bucket"
}

# Modul für Cognito
module "cognito" {
  source        = "./modules/cognito"
  environment   = var.environment
  callback_urls = ["https://example.com/callback"]  # Passen Sie diese URL an
  logout_urls   = ["https://example.com/logout"]    # Passen Sie diese URL an
}

# Modul für CloudFront
module "cloudfront" {
  source        = "./modules/cloudfront"
  environment   = var.environment
  s3_bucket_name = module.s3.bucket_name
}

# Konsolidierte Outputs, um nützliche Informationen aus den Modulen zu sammeln
output "iam_role_arn" {
  description = "ARN der IAM-Rolle"
  value       = module.iam.iam_role_arn
}

output "cloudwatch_high_cpu_alarm_arn" {
  description = "ARN des CloudWatch CPU Alarms"
  value       = module.cloudwatch.high_cpu_alarm_arn
}

output "alb_dns_name" {
  description = "DNS Name des Application Load Balancers"
  value       = module.alb.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name der Autoscaling Gruppe"
  value       = module.autoscaling.autoscaling_group_name
}

output "api_gateway_endpoint" {
  description = "Endpoint des API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "rds_endpoint" {
  description = "Endpoint der RDS-Datenbank"
  value       = module.rds.endpoint
}

output "s3_bucket_name" {
  description = "Name des S3 Buckets"
  value       = module.s3.bucket_name
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.cognito.user_pool_client_id
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = module.cloudfront.cloudfront_domain_name
}
