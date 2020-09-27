#https://medium.com/@gmusumeci/how-to-deploy-aws-ecs-fargate-containers-step-by-step-using-terraform-545eeac743be

data "aws_caller_identity" "current" {}

data "aws_ami" "default" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

locals {
  tags = {
    Environment = var.cluster_environment
    App = var.cluster_name
    ManagedBy = "terraform"
  }
  cluster_full_name = "${var.cluster_name}-${var.cluster_environment}"
}



