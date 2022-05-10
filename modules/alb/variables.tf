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
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "security_groups" {
  description = "Security group id"
  type        = string
}
variable "subnets" {
  description = "List of subnets"
  type        = list(any)
  default     = ["subnet-04540182cb1b76d61", "subnet-0069a5bd56d080f69"]
}