locals {
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
  tags = {
    Environment = var.environment
    App         = var.cluster_name
    ManagedBy   = "terraform"
  }
}

provider "aws" {
  region = var.aws_region
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

module "ecs_cluster" {
  source = "./../../modules/ecs-cluster"

  instance_region   = var.aws_region
  instance_key_name = var.cluster_ssh_key
  environment       = var.environment
  name              = var.cluster_name

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id
}

module "ecs_statping" {
  source = "./../../modules/statping"

  aws_region               = var.aws_region
  cluster_name             = module.ecs_cluster.ecs_cluster_name
  cluster_vpc_id           = module.vpc.vpc_id
  cluster_enable_https     = true
  cluster_lb_cidr          = var.cluster_lb_cidr
  cluster_hosted_zone_name = var.cluster_hosted_zone_name

  cluster_private_subnets = module.vpc.private_subnets
  cluster_public_subnets  = module.vpc.public_subnets

  statping_domain = var.statping_domain
}
