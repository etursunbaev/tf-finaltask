locals {
  iam_iparn = var.instance_profile
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

resource "aws_launch_template" "this_tmpl" {
  name = "ghost"

  iam_instance_profile {
    arn = local.iam_iparn
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
    security_groups = var.security_groups
  }

  #vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = var.user_data
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