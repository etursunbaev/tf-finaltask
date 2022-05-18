locals {
  prefix   = var.prefix_name
  app_name = var.app_name
  tags     = var.additional_tags
}
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${local.prefix}-${local.app_name}-lg"
  retention_in_days = var.retention_period
  tags              = local.tags
}