variable "additional_tags" {
  description = "Common tags to be merged"
  type        = map(string)
}
variable "prefix_name" {
  description = "Prefix name"
  type        = string
}
variable "app_name" {
  description = "Application name"
  type        = string
}
variable "retention_period" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 1
}