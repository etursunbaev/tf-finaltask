#create_ecs  = false
environment = "dev"
additional_tags = {
  "Departament" = "IT"
  "Platform"    = "Container"
  "ManagedBy"   = "Terraform"
}
repo_url         = "298205446974.dkr.ecr.us-east-1.amazonaws.com/dynamo"
db_name          = "ghost"
db_password      = "asds88"
db_url_tpl       = "127.0.0.1"
db_user          = "ghuser"
vpc_id           = "vpc-1230"
create_ecs       = true
security_groups  = "sg-1234"
subnets          = ["subnet-1234"]
efs_id           = "efs-1233"
fargate_pool_arn = "arn:aws:elasticloadbalancing:us-east-1:298205446974:targetgroup/ghost-fargate/9d0e67148c6bcb9b"
log_group        = "ecs-cls"