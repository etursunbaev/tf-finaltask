variable "target_groups" {
  description = "Target group names"
  type        = list(any)
  default     = ["ghost-ec2", "ghost-fargate"]
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags"
  type        = map(string)
  default     = {}
}