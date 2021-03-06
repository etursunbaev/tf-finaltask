provider "aws" {
  region = var.aws_region
}

locals {
  pub_key_name = "ghost-ec2-pool"
  tags = merge(var.additional_tags, {
    Environment = var.environment
    },
  )
  cidr_block       = var.vpc_cidr_block
  create_vpc       = var.create_vpc
  vpc_name         = var.vpc_name
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
  create_igw       = var.create_igw
  db_name          = "gh_db"
  db_user          = "gh_user"
  prefix_name      = "cloudx"
  app_name         = "ghost"
  retention_period = 1
}

resource "tls_private_key" "generated" {
  algorithm = var.tls_algorithm
  rsa_bits  = var.tls_bits
}

resource "aws_key_pair" "public_key" {
  key_name   = local.pub_key_name
  public_key = tls_private_key.generated.public_key_openssh
  tags       = local.tags
}

resource "local_file" "save_priv_key_pem" {
  filename        = "${path.module}/${local.pub_key_name}.pem"
  content         = tls_private_key.generated.private_key_pem
  file_permission = "0600"
}

module "vpc" {
  source           = "./modules/network"
  create_vpc       = local.create_vpc
  vpc_cidr_block   = local.cidr_block
  additional_tags  = var.additional_tags
  vpc_name         = local.vpc_name
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = var.database_subnets
  create_igw       = local.create_igw
  azs              = var.azs
}

module "sg" {
  source           = "./modules/sg"
  vpc_id           = module.vpc.vpc_id
  data_http_ip_url = var.data_http_ip_url
  additional_tags  = local.tags
  depends_on = [
    module.vpc
  ]
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  additional_tags = local.tags
  db_name         = local.db_name
  db_user         = local.db_user
  db_sg           = [module.sg.mysql_sg]
  depends_on = [
    module.vpc,
    module.sg
  ]
}

module "efs" {
  source          = "./modules/efs"
  vpc_id          = module.vpc.vpc_id
  additional_tags = local.tags
  subnets         = module.vpc.private_subnets
  efs_sg          = [module.sg.efs_sg]
  depends_on = [
    module.vpc,
    module.sg
  ]
}

module "alb" {
  source          = "./modules/alb"
  additional_tags = local.tags
  target_groups   = var.target_groups
  vpc_id          = module.vpc.vpc_id
  security_groups = module.sg.alb_sg
  subnets         = module.vpc.public_subnets
  prefix_name     = local.prefix_name
  alb_group       = var.alb_group
  image_id = var.image_id
  instance_type = var.instance_type
  depends_on = [
    module.vpc,
    module.sg,
    module.asg
  ]
}

module "asg" {
  source           = "./modules/asg"
  additional_tags  = local.tags
  environment      = var.environment
  instance_type    = var.instance_type
  pub_key_name     = local.pub_key_name
  image_id         = var.image_id
  instance_profile = aws_iam_instance_profile.this_profile.arn
  security_groups  = [module.sg.ec2_pool_sg]
  subnets          = module.vpc.public_subnets
  db_host          = module.rds.db_instance_ip
  db_password      = module.rds.master_pwd
  db_name          = local.db_name
  db_user          = local.db_user
  aws_region       = var.aws_region
  efs_id           = module.efs.efs_id
  depends_on = [
    aws_iam_instance_profile.this_profile,
    module.vpc,
    module.sg,
    module.rds,
    module.efs
  ]
}

resource "aws_iam_instance_profile" "this_profile" {
  name = "ghost_app_instance_profile"
  role = aws_iam_role.this_ecsInstanceRole.name
  tags = local.tags
}

resource "aws_iam_role" "this_ecsInstanceRole" {
  name               = "ghost-app-role"
  assume_role_policy = file("policies/ecsInstanceRoleAssumeRolePolicy.json")
  tags               = local.tags
}

resource "aws_iam_role_policy" "this_ecsInstanceRolePolicy" {
  name   = "ghost-app-role-policy"
  role   = aws_iam_role.this_ecsInstanceRole.id
  policy = file("policies/ecsInstancerolePolicy.json")
}

# module "ecr" {
#   source = "./modules/ecr"
# }

# module "ecs" {
#   source                  = "./modules/ecs"
#   environment             = var.environment
#   additional_tags         = local.tags
#   create_ecs              = true
#   launch_type             = "FARGATE"
#   repo_url                = module.ecr.repo_url
#   ecs_task_execution_role = aws_iam_role.this_ecsInstanceRole.arn
#   vpc_id                  = module.vpc.vpc_id
#   security_groups         = module.sg.fargate_pool_sg
#   subnets                 = module.vpc.private_subnets
#   efs_id                  = module.efs.efs_id
#   fargate_pool_arn        = module.alb.fargate_tgn
#   db_url_tpl              = module.rds.db_instance_ip
#   db_name                 = local.db_name
#   db_user                 = local.db_user
#   db_password             = module.rds.master_pwd
#   log_group               = module.logs.log_group
#   depends_on = [
#     module.ecr,
#     module.vpc,
#     module.alb,
#     module.sg,
#     module.rds,
#     module.efs,
#     module.logs
#   ]
# }

# data "template_file" "image_push" {
#   template = file("scripts/image.sh")
#   vars = {
#     "repo_url" = module.ecr.repo_url
#   }
# }

# resource "null_resource" "push" {
#   provisioner "local-exec" {
#     command = data.template_file.image_push.rendered
#   }
#   depends_on = [
#     module.ecr
#   ]
# }
# module "vpce" {
#   source        = "./modules/vpce"
#   vpc_id        = module.vpc.vpc_id
#   vpce_sg       = [module.sg.vpce_sg]
#   private_rt_id = module.vpc.private_rt
#   subnets       = module.vpc.public_subnets
#   depends_on = [
#     module.vpc,
#     module.sg
#   ]
# }
# module "logs" {
#   source           = "./modules/logs"
#   additional_tags  = local.tags
#   prefix_name      = local.prefix_name
#   app_name         = local.app_name
#   retention_period = local.retention_period
# }