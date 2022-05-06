variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-02532678f469d05ca"
}
variable "random_password_length" {
  description = "Length of random password to create. Defaults to `10`"
  type        = number
  default     = 10
}
variable "vpc_security_group_ids" {
  description = "The VPC security group ID"
  type        = string
  default     = "sg-03050aeecb3a545d2"
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags"
  type        = map(string)
  default     = {}
}