variable "tls_algorithm" {
  description = "TLS Private Key algorithm type."
  type        = string
  default     = "RSA"
}
variable "tls_bits" {
  description = "TLS Bits."
  type        = number
  default     = 4096
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags."
  type        = map(string)
  default     = {}
}
variable "aws_region" {
  description = "The AWS region to use in."
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block"
  type        = string
}
variable "vpc_name" {
  description = "VPC name"
  type        = string
}
variable "create_vpc" {
  description = "Create VPC?"
  type        = bool
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
variable "create_igw" {
  description = "Create Internet Gateway resource?"
  type        = bool
}
variable "azs" {
  description = "Availabity zones to launch in"
  type        = list(any)
}
variable "data_http_ip_url" {
  description = "Public resource to retrieve your home network ip."
  type        = string
}
variable "target_groups" {
  description = "Target group names"
  type        = list(any)
  default     = ["ghost-ec2", "ghost-fargate"]
}
variable "instance_type" {
  description = "The EC2 instance type to use."
  type        = string
  default     = "t2.micro"
}
variable "default_image_id" {
  description = "Default AMI ID if image_id is unknown."
  type        = string
  default     = "ami-0f260fe26c2826a3d"
}
variable "image_id" {
  description = "The AMI ID."
  type        = string
}