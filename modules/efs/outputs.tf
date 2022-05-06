output "efs_id" {
  description = "EFS ID"
  value       = aws_efs_file_system.this_efs.id
}