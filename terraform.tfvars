additional_tags = {
  "Departament" = "IAD"
  "ManagedBy"   = "Terraform"
  "Owner"       = "Eldar Tursunbaev"
}
environment      = "test"
vpc_cidr_block   = "10.10.0.0/16"
vpc_name         = "cloudx"
create_vpc       = true
public_subnets   = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnets  = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
database_subnets = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
create_igw       = true
azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
data_http_ip_url = "http://ifconfig.io/ip"
image_id         = "ami-0022f774911c1d690"
alb_group = {
  target-1 = {
    name        = "ghost-ec2"
    target_type = "instance"
  },
  target-2 = {
    name        = "ghost-fargate"
    target_type = "ip"
  }
}