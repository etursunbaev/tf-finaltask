output "tgs" {
  description = "Target Groups ARN"
  value       = aws_lb_target_group.this_tg.*.arn
}
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
  value       = aws_lb_target_group.this_tg[1].arn
}