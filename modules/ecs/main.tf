locals {
  extra_tags = merge(var.additional_tags, {
    Environment = var.environment
    },
  )
}
resource "aws_ecs_cluster" "this_cluster" {
  name = "ghost"
  tags = local.extra_tags
}
resource "aws_ecs_service" "this_service" {
  name            = "ghost-service"
  cluster         = aws_ecs_cluster.this_cluster.arn
  launch_type     = var.launch_type
  task_definition = aws_ecs_task_definition.this_task.arn
  #desired_count       = var.desired_count
  scheduling_strategy = "DAEMON"
  tags                = local.extra_tags
}
resource "aws_ecs_task_definition" "this_task" {
  family                = "ghost-task"
  task_role_arn         = var.ecs_task_execution_role
  container_definitions = file("${path.module}/templates/task-definition.json")
  tags                  = local.extra_tags
}
resource "aws_ecr_repository" "foo" {
  name                 = "ghost-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}