output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
output "public_subnets" {
  description = "Public subnets ID"
  value       = module.vpc.public_subnets
}
output "private_subnets" {
  description = "Private subnets ID"
  value       = module.vpc.private_subnets
}
output "database_subnets" {
  description = "Database subnets ID"
  value       = module.vpc.database_subnets
}
output "public_rt" {
  description = "Public Route Table ID"
  value       = module.vpc.public_rt
}
output "private_rt" {
  description = "Private Route Table ID"
  value       = module.vpc.private_rt
}
output "igw" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw
}
output "ec2_pool_sg" {
  description = "EC2 pool security group ID"
  value       = module.sg.ec2_pool_sg
}
output "fargate_pool_sg" {
  description = "Fargate pool security group ID"
  value       = module.sg.fargate_pool_sg
}
output "mysql_sg" {
  description = "MySQL security group ID"
  value       = module.sg.mysql_sg
}
output "efs_sg" {
  description = "EFS security group ID"
  value       = module.sg.efs_sg
}
output "alb_sg" {
  description = "ALB security group ID"
  value       = module.sg.alb_sg
}
output "vpce_sg" {
  description = "VPC Endpoint security group ID"
  value       = module.sg.vpce_sg
}
output "db_subnet_id" {
  description = "DB subnet ID"
  value       = module.rds.db_subnet_id
}
output "db_instance_ip" {
  description = "DB instance IP address"
  value       = module.rds.db_instance_ip
}
output "efs_id" {
  description = "EFS ID"
  value       = module.efs.efs_id
}
output "ec2_tgn" {
  description = "Target Groups ARN"
  value       = module.alb.ec2_tgn
}
output "fargate_tgn" {
  description = "Target Groups ARN"
  value       = module.alb.fargate_tgn
}
output "alb" {
  description = "ALB ARN"
  value       = module.alb.alb
}
output "listener" {
  description = "Listener ARN"
  value       = module.alb.listener
}
output "asg" {
  description = "ASG arn"
  value       = module.asg.asg
}
output "launch_template" {
  description = "Launch template ARN"
  value       = module.asg.launch_template
}
# output "repo_url" {
#   description = "The URL of the repository"
#   value       = module.ecr.repo_url
# }
output "instance_id" {
  description = "Instance ID"
  value       = module.alb.instance_id
}
output "instance_ip" {
  description = "Instance IP"
  value       = module.alb.public_ip
}
