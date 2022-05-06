resource "aws_lb" "this_alb" {
  name               = "ALB"
  load_balancer_type = "application"
  tags = merge(var.additional_tags, {
    Name = "ALB"
    },
  )
}
resource "aws_lb_target_group" "this_tg" {
  count       = length(var.target_groups)
  name        = var.target_groups[count.index]
  target_type = "ip"
  protocol    = "HTTP"
  port        = 2368
  tags        = var.additional_tags
}
resource "aws_lb_listener" "this_listener" {
  #count = length(aws_lb_target_group.this_tg.*.id)
  load_balancer_arn = aws_lb.this_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_tg[0].arn
  }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_tg[1].arn
  }

}
resource "aws_lb_listener_rule" "this_rule" {
  listener_arn = aws_lb_listener.this_listener.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.this_tg[0].arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.this_tg[1].arn
        weight = 50
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }
  condition {
    http_header {
      http_header_name = "X-Forwarded-For"
      values           = ["192.168.1.*"]
    }
  }
}