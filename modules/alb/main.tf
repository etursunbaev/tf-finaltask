locals {
  prefix = var.prefix_name
}
resource "aws_lb" "this_alb" {
  name               = "${local.prefix}-ALB"
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets
  tags = merge(var.additional_tags, {
    Name = "ALB"
    },
  )
}
resource "aws_lb_target_group" "this_tg" {
  #count       = length(var.target_groups)
  for_each    = var.alb_group
  name        = each.value.name
  target_type = each.value.target_type
  protocol    = "HTTP"
  port        = 2368
  tags        = var.additional_tags
  vpc_id      = var.vpc_id
}
resource "aws_lb_listener" "this_listener" {
  #count = length(aws_lb_target_group.this_tg.*.id)
  load_balancer_arn = aws_lb.this_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.this_tg["target-1"].arn
        weight = 50
      }
      target_group {
        arn    = aws_lb_target_group.this_tg["target-2"].arn
        weight = 50
      }
    }
  }

}
data "aws_instance" "this_instance" {
  filter {
    name   = "image-id"
    values = [var.image_id]
  }
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}
# resource "aws_lb_listener_rule" "this_rule" {
#   listener_arn = aws_lb_listener.this_listener.arn
#   priority     = 99

#   action {
#     type = "forward"
#     forward {
#       target_group {
#         arn    = aws_lb_target_group.this_tg[0].arn
#         weight = 50
#       }

#       target_group {
#         arn    = aws_lb_target_group.this_tg[1].arn
#         weight = 50
#       }

#       stickiness {
#         enabled  = true
#         duration = 600
#       }
#     }
#   }
#   condition {
#     http_header {
#       http_header_name = "X-Forwarded-For"
#       values           = ["192.168.1.*"]
#     }
#   }
# }
resource "aws_lb_target_group_attachment" "this_attachment" {
  target_group_arn = aws_lb_target_group.this_tg["target-1"].arn
  target_id        = data.aws_instance.this_instance.id
}