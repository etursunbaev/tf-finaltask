variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-07cd9d49716512fb2"
}
variable "vpce_sg" {
  description = "VPCE security group"
  type        = list(any)
  default     = ["sg-087e04381da40f489"]
}
variable "private_rt_id" {
  description = "Private route table"
  type        = string
  default     = "rtb-00467e4d4874a9139"
}
variable "subnets" {
  description = "The ID of one or more subnets in which to create a network interface for the endpoint. "
  type        = list(any)
}