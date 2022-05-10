variable "vpc_id" {
    description = "VPC ID"
    type = string
}
variable "vpce_sg" {
    description = "VPCE security group"
    type = list
}
variable "private_rt_id" {
    description = "Private route table"
    type = string
}