create_vpc = true
additional_tags = {
  "Department"   = "IT"
  "Owner"        = "Eldar Tursunbaev"
  "Organization" = "EPAM"
}
public_subnets   = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnets  = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
database_subnets = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
create_igw       = true