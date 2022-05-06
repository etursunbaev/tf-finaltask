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
}
module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  additional_tags = local.tags
}
module "efs" {
  source          = "./modules/efs"
  vpc_id          = module.vpc.vpc_id
  additional_tags = local.tags
  subnets         = module.vpc.private_subnets
}
module "alb" {
  source          = "./modules/alb"
  additional_tags = local.tags
  target_groups   = var.target_groups
}
module "asg" {
  source           = "./modules/asg"
  additional_tags  = local.tags
  environment      = var.environment
  db_host          = module.rds.db_instance_ip
  efs_id           = module.efs.efs_id
  db_password      = module.rds.master_pwd
  instance_type    = var.instance_type
  pub_key_name     = local.pub_key_name
  image_id         = var.image_id
  instance_profile = aws_iam_instance_profile.this_profile.role
  security_groups  = [module.sg.ec2_pool_sg]
  aws_region       = var.aws_region
}
resource "aws_iam_instance_profile" "this_profile" {
  name = "ghost_app"
  role = aws_iam_role.this_ecsInstanceRole.name
  tags = local.tags
}
resource "aws_iam_role" "this_ecsInstanceRole" {
  name               = "ecsInstanceRole"
  assume_role_policy = file("policies/ecsInstanceRoleAssumeRolePolicy.json")
  tags               = local.tags
}
resource "aws_iam_role_policy" "this_ecsInstanceRolePolicy" {
  name   = "ecsInstanceRolePolicy"
  role   = aws_iam_role.this_ecsInstanceRole.id
  policy = file("policies/ecsInstancerolePolicy.json")
}
module "ecs" {
  source      = "./modules/ecs"
  environment = var.environment
  create_ecs  = true
  launch_type = "FARGATE"
}