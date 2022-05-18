data "aws_vpc" "this_vpc" {
  id = var.vpc_id
}
data "http" "my_ip" {
  url = var.data_http_ip_url
}
resource "aws_security_group" "ec2_pool" {
  name        = "ec2_pool"
  description = "allows access for ec2 instances"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "ec2_pool"
    },
  )
  ingress {
    description = "SSH from my home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  ingress {
    description = "Access from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = "Open internet"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "fargate_pool" {
  name        = "fargate_pool"
  description = "allows access for fargate instances"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "fargate_pool"
    },
  )
  ingress {
    description = "Access from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = "Open internet"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "this_mysql" {
  name        = "mysql"
  description = "defines access to ghost db"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "mysql"
    },
  )
  ingress {
    description     = "Access from instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_pool.id, aws_security_group.fargate_pool.id]
  }
}
resource "aws_security_group" "this_efs" {
  name        = "efs"
  description = "defines access to efs mount points"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "efs"
    },
  )
  ingress {
    description     = "Access from instances"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_pool.id, aws_security_group.fargate_pool.id]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = "Open internet"
    cidr_blocks = [data.aws_vpc.this_vpc.cidr_block]
  }
}
resource "aws_security_group" "this_alb" {
  name        = "alb"
  description = "defines access to alb"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "alb"
    },
  )
  ingress {
    description = "HTTP access from my home"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ec2_pool.id, aws_security_group.fargate_pool.id]
  }
}
resource "aws_security_group" "this_vpce" {
  name        = "vpc_endpoint"
  description = "defines access to vpc endpoints"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : var.default_vpc_id
  tags = merge(var.additional_tags, {
    Name = "vpc_endpoint"
    },
  )
  ingress {
    description = "HTTPS access from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = "Open internet"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "extra_ec2_rule" {
  type                     = "ingress"
  description              = "Access from ALB"
  from_port                = 2368
  to_port                  = 2368
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_pool.id
  source_security_group_id = aws_security_group.this_alb.id
}
resource "aws_security_group_rule" "extra_fargate_rule" {
  type                     = "ingress"
  description              = "Access from ALB"
  from_port                = 2368
  to_port                  = 2368
  protocol                 = "tcp"
  security_group_id        = aws_security_group.fargate_pool.id
  source_security_group_id = aws_security_group.this_alb.id
}