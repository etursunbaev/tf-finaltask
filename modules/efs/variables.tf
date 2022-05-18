variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02532678f469d05ca"
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags"
  type        = map(string)
  default     = {}
}
variable "subnets" {
  description = "Subnet ids"
  type        = list(any)
}
variable "efs_sg" {
  description = "A list of up to 5 VPC security group IDs"
  type        = list(any)
}