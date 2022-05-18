output "asg" {
  description = "ASG ARN"
  value       = aws_autoscaling_group.this_asg.arn
}
output "launch_template" {
  description = "Launch template ARN"
  value       = aws_launch_template.this_tmpl.arn
}
