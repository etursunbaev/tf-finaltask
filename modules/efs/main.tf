resource "aws_efs_file_system" "this_efs" {
  creation_token = "ghost_content"
  tags = merge(var.additional_tags, {
    Name = "ghost_content"
    },
  )
}
resource "aws_efs_mount_target" "this_mount" {
  count           = length(var.subnets)
  file_system_id  = aws_efs_file_system.this_efs.id
  subnet_id       = var.subnets[count.index]
  security_groups = var.efs_sg
}