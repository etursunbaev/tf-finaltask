output "ec2_pool_sg" {
  description = "EC2 pool security group ID"
  value       = aws_security_group.ec2_pool.id
}
output "fargate_pool_sg" {
  description = "Fargate pool security group ID"
  value       = aws_security_group.fargate_pool.id
}
output "mysql_sg" {
  description = "MySQL security group ID"
  value       = aws_security_group.this_mysql.id
}
output "efs_sg" {
  description = "EFS security group ID"
  value       = aws_security_group.this_efs.id
}
output "alb_sg" {
  description = "ALB security group ID"
  value       = aws_security_group.this_alb.id
}
output "vpce_sg" {
  description = "VPC Endpoint security group ID"
  value       = aws_security_group.this_vpce.id
}



