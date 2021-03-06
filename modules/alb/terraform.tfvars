additional_tags = {
  "Department"   = "IT"
  "Owner"        = "Eldar Tursunbaev"
  "Organization" = "EPAM"
}
subnets         = ["subnet-04540182cb1b76d61", "subnet-0069a5bd56d080f69"]
security_groups = "sg-03050aeecb3a545d2"
vpc_id          = "vpc-02532678f469d05ca"
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
prefix_name = "cloudx"