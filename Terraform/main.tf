# AWS Provider-Konfiguration
provider "aws" {
  region = "us-east-1"  # Passen Sie die Region an Ihre Bedürfnisse an
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

# Konsolidierte Outputs, um nützliche Informationen aus den Modulen zu sammeln
output "iam_role_arn" {
  value = module.iam.iam_role_arn
}

output "cloudwatch_high_cpu_alarm_arn" {
  value = module.cloudwatch.high_cpu_alarm_arn
}
