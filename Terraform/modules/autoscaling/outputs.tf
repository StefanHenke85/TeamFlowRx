output "autoscaling_group_name" {
  description = "Name of the Autoscaling group"
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.app_lt.id
}

output "scaling_policy_out_name" {
  description = "Name of the scale-out policy"
  value       = aws_autoscaling_policy.scale_out.name
}

output "scaling_policy_in_name" {
  description = "Name of the scale-in policy"
  value       = aws_autoscaling_policy.scale_in.name
}
