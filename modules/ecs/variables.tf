variable "environment" {
  description = "The environment name to use in configuration."
  type        = string
}
variable "create_ecs" {
  description = "Create ECS or not?"
  type        = bool
}
variable "launch_type" {
  description = "The ECS service launch type."
  type        = string
  default     = "EC2"
}
variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  type        = number
  default     = 1
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags."
  type        = map(string)
  default     = {}
}
variable "ecs_task_execution_role" {
  description = "ECS task execution role ARN."
  type        = string
  default     = ""
}
variable "repo_url" {
  description = "Repository URL"
  type        = string
}
variable "vpc_id" {
  description = "value"  
  type = string
}
variable "security_groups" {
  description = "Security group ID"
  type = string
}
variable "subnets" {
  description = "Subnets"
  type = list
}
variable "efs_id" {
  description = "EFS ID"
  type = string
}
variable "fargate_pool_arn" {
  description = "Fargate target"
  type = string
}