locals {
  extra_tags = [
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "Departament"
      value               = can(var.additional_tags.Departament) ? lookup(var.additional_tags, "Departament") : null
      propagate_at_launch = can(var.additional_tags.Departament)
    },
    {
      key                 = "ManagedBy"
      value               = can(var.additional_tags.ManagedBy) ? lookup(var.additional_tags, "ManagedBy") : null
      propagate_at_launch = can(var.additional_tags.ManagedBy)
    },
    {
      key                 = "Platform"
      value               = can(var.additional_tags.Platform) ? lookup(var.additional_tags, "Platform") : null
      propagate_at_launch = can(var.additional_tags.Platform)
    }
  ]
}
data "template_file" "user_data" {
  template = file("${path.module}/init.sh")

  vars = {
    db_url_tpl  = var.db_host
    db_password = var.db_password
    efs_id      = var.efs_id
    aws_region  = var.aws_region
  }
}
resource "aws_launch_template" "this_tmpl" {
  name = "ghost"

  iam_instance_profile {
    name = "test"
  }

  image_id = var.image_id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.pub_key_name

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = data.template_file.user_data.rendered
}
resource "aws_autoscaling_group" "this_asg" {
  name     = "ghost_ec2_pool"
  max_size = var.asg_max_size
  min_size = var.asg_min_size
  launch_template {
    id      = aws_launch_template.this_tmpl.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnets
  tags                = local.extra_tags
}