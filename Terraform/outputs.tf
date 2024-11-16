output "iam_role_arn" {
  value = module.iam.iam_role_arn
}

output "cloudwatch_high_cpu_alarm_arn" {
  value = module.cloudwatch.high_cpu_alarm_arn
}
