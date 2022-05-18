output "alb" {
  description = "ALB ARN"
  value       = aws_lb.this_alb.arn
}
output "listener" {
  description = "Listener ARN"
  value       = aws_lb_listener.this_listener.arn
}
output "fargate_tgn" {
  description = "Fargate ARN"
  value       = aws_lb_target_group.this_tg["target-2"].arn
}
output "ec2_tgn" {
  description = "Fargate ARN"
  value       = aws_lb_target_group.this_tg["target-1"].arn
}
output "instance_id" {
  description = "Instance ID"
  value       = data.aws_instance.this_instance.id
}
output "public_ip" {
  description = "Instance Public IP"
  value       = data.aws_instance.this_instance.public_ip
}