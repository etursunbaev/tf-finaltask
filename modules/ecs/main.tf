locals {
  extra_tags = merge(var.additional_tags, {
    Environment = var.environment
    },
  )
}
data "template_file" "task_definition_template" {
  template = file("${path.module}/templates/task-definition.json")
  vars = {
    "repo_url" = var.repo_url
  }
}

resource "aws_ecs_cluster" "this_cluster" {
  name = "cloudx-ghost"
  tags = local.extra_tags
}
resource "aws_ecs_service" "this_service" {
  name            = "cloudx-ghost-service"
  cluster         = aws_ecs_cluster.this_cluster.arn
  launch_type     = var.launch_type
  task_definition = aws_ecs_task_definition.this_task.arn
  #platform_version = "1.3.0"
  desired_count = 1
  #scheduling_strategy = "DAEMON"
  tags = local.extra_tags
  network_configuration {
    #subnets = data.aws_subnets.this_subnets.ids
    subnets          = var.subnets
    security_groups  = [var.security_groups]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.fargate_pool_arn
    container_name   = "cloudx-ghost-container"
    container_port   = 2368
  }
}
resource "aws_ecs_task_definition" "this_task" {
  family             = "cloudx-ghost-task"
  task_role_arn      = var.ecs_task_execution_role
  execution_role_arn = var.ecs_task_execution_role
  container_definitions = jsonencode(
    [
      {
        name      = "cloudx-ghost-container"
        image     = "${var.repo_url}:latest"
        cpu       = 256
        memory    = 1024
        essential = true
        portMappings = [
          {
            containerPort = 2368
            hostPort      = 2368
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.log_group
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "streaming"
          }
        }
        environment = [
          {
            name  = "database__client"
            value = "mysql"
          },
          {
            name  = "database__connection__host"
            value = var.db_url_tpl
          },
          {
            name  = "database__connection__user"
            value = var.db_user
          },
          {
            name  = "database__connection__password"
            value = var.db_password
          },
          {
            name  = "database__connection__database"
            value = var.db_name
          }
        ]
        mountPoints = [
          {
            sourceVolume  = "efs-storage"
            containerPath = "/var/lib/ghost/content"
          }
        ]
      }
    ]
  )
  tags                     = local.extra_tags
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
  cpu    = 256
  memory = 1024

  volume {
    name = "efs-storage"
    efs_volume_configuration {
      file_system_id = var.efs_id
      root_directory = "/"
    }
  }
}

