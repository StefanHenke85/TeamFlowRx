output "autoscaling_group_name" {
  description = "Name of the Autoscaling group"
  value       = aws_autoscaling_group.app_asg.name
}
