variable "vpc_cidr_block" {
  description = "CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}
variable "create_vpc" {
  description = "Create VPC?"
  type        = bool
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags"
  type        = map(string)
  default     = {}
}
variable "public_subnets" {
  description = "Public subnet CIDR"
  type        = list(any)
}
variable "private_subnets" {
  description = "Private subnet CIDR"
  type        = list(any)
}
variable "database_subnets" {
  description = "Database subnet CIDR"
  type        = list(any)
}
variable "azs" {
  description = "Availabity zones to launch in"
  type        = list(any)
}
variable "create_igw" {
  description = "Create Internet Gateway resource?"
  type        = bool
}
variable "vpc_name" {
  description = "VPC name"
  type        = string
}