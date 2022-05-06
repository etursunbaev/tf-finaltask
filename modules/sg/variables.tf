variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}
variable "default_vpc_id" {
  description = "Default VPC ID if other is not set"
  type        = string
  default     = "vpc-02532678f469d05ca"
}
variable "additional_tags" {
  description = "Common Tags to be merged with main tags"
  type        = map(string)
  default     = {}
}
variable "data_http_ip_url" {
  description = "Public resource to retrieve your home network ip."
  type        = string
  default     = ""
}