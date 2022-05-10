locals {
  extra_tags = merge(var.additional_tags, {
    Environment = var.environment
    },
  )
}
data "template_file" "task_definition_template" {
  template = file("${path.module}/templates/task-definition.json")
  vars = {
    "repo_url"   = var.repo_url
  }
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
  #platform_version = "1.3.0"
  desired_count       = 1
  #scheduling_strategy = "DAEMON"
  tags                = local.extra_tags
  network_configuration {
    #subnets = data.aws_subnets.this_subnets.ids
    subnets = var.subnets
    security_groups = [var.security_groups]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.fargate_pool_arn
    container_name = "ghost-container"
    container_port = 2368
  }
}
resource "aws_ecs_task_definition" "this_task" {
  family                = "ghost-task"
  task_role_arn         = "arn:aws:iam::298205446974:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::298205446974:role/ecsTaskExecutionRole"
  container_definitions = data.template_file.task_definition_template.rendered
  tags                  = local.extra_tags
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
  cpu = 256
  memory = 1024
  volume {
    name = "efs-storage"
      efs_volume_configuration {
        file_system_id = var.efs_id
        root_directory = "/var/lib/ghost/content"
      }  
  }
}

