locals {
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
}

data "aws_availability_zones" "default" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name            = var.cluster_name
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.default.names
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
