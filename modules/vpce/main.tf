resource "aws_vpc_endpoint" "ecr" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.ecr.api"
    vpc_endpoint_type = "Interface"
    security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint" "ecr-dkr" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.ecr.dkr"
    vpc_endpoint_type = "Interface"
    security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint" "ssm" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.ssm"
    vpc_endpoint_type = "Interface"
    security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint" "efs" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.elasticfilesystem"
    vpc_endpoint_type = "Interface"
    security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint" "S3" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.s3"
    vpc_endpoint_type = "Gateway"
    # security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint" "cloudwatch" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.us-east-1.logs"
    vpc_endpoint_type = "Interface"
    security_group_ids = var.vpce_sg
}
resource "aws_vpc_endpoint_route_table_association" "assosi" {
  route_table_id  = var.private_rt_id
  vpc_endpoint_id = aws_vpc_endpoint.S3.id
}