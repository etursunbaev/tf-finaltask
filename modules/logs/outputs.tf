output "log_group" {
  description = "Log group name"
  value       = aws_cloudwatch_log_group.log_group.name
}