output "db_subnet_id" {
  description = "DB subnet ID"
  value       = aws_db_subnet_group.this_db_subnet.id
}
output "db_instance_ip" {
  description = "DB instance IP address"
  value       = aws_db_instance.this_db.address
}
output "master_pwd" {
  description = "DB master pwd"
  value       = random_password.master_password.result
  sensitive   = true
}
output "test" {
  value = data.aws_subnets.this_subnets.ids
}