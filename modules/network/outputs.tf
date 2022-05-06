output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this_vpc.id
}
output "public_subnets" {
  description = "Public subnets ID"
  value       = aws_subnet.this_public.*.id
}
output "private_subnets" {
  description = "Private subnets ID"
  value       = aws_subnet.this_private.*.id
}
output "database_subnets" {
  description = "Database subnets ID"
  value       = aws_subnet.this_dbs.*.id
}
output "public_rt" {
  description = "Public Route Table ID"
  value       = aws_route_table.this_prt[0].id
}
output "private_rt" {
  description = "Private Route Table ID"
  value       = aws_route_table.this_private_rt[0].id
}
output "igw" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this_igw[0].id
}