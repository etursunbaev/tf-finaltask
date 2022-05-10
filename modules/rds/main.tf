locals {
  db_sg = data.aws_security_groups.this_sg.ids != [] ? data.aws_security_groups.this_sg.ids : [var.vpc_security_group_ids]
}
data "aws_subnets" "this_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["private_db_*"] # insert values here
  }
  # tags = {
  #   Name = "private_db*"
  # }
}
data "aws_security_groups" "this_sg" {

  filter {
    name   = "group-name"
    values = ["mysql"]
  }
}
resource "aws_db_subnet_group" "this_db_subnet" {
  name        = "ghost"
  description = "ghost database subnet group"
  subnet_ids  = data.aws_subnets.this_subnets.ids
  tags = merge(var.additional_tags, {
    Name = "ghost"
    },
  )
}
resource "aws_db_instance" "this_db" {
  allocated_storage      = 20
  identifier = "ghost"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  db_name                = "gh_db"
  username               = "gh_user"
  password               = random_password.master_password.result
  storage_type           = "gp2"
  vpc_security_group_ids = local.db_sg
  db_subnet_group_name   = aws_db_subnet_group.this_db_subnet.name
  skip_final_snapshot  = true
  tags = merge(var.additional_tags, {
    Name = "ghost"
    },
  )
}
resource "random_password" "master_password" {
  length  = var.random_password_length
  special = false
}
resource "aws_ssm_parameter" "secret" {
  name        = "/ghost/dbpassw"
  description = "The parameter description"
  type        = "SecureString"
  value       = random_password.master_password.result
  tags = merge(var.additional_tags, {
    Name = "master pwd"
    },
  )
}