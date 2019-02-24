locals {
  cidr_head = "${element(split(".",var.cidr), 0)}.${element(split(".",var.cidr), 1)}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.57.0"

  name = "vpc-cloud9"
  cidr = "${var.cidr}"

  azs             = ["ap-southeast-1a","ap-southeast-1c"]
  private_subnets = ["${local.cidr_head}.1.0/24", "${local.cidr_head}.2.0/24"]
  public_subnets  = ["${local.cidr_head}.11.0/24", "${local.cidr_head}.12.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "cloud9"
  } 
}

resource "aws_cloud9_environment_ec2" "cloud9" {
  instance_type = "t2.micro"
  name          = "cloud9"
  subnet_id     = "${module.vpc.public_subnets[0]}"  
}
