module "ecs_cluster" {
  source      = "./modules/ecs-cluster"
  name        = var.cluster_name
  environment = var.cluster_environment

  vpc_id = module.vpc.vpc_id

  image_id          = data.aws_ami.default.image_id
  instance_type     = var.cluster_instance_type
  instance_region   = var.aws_region
  instance_key_name = var.cluster_ssh_key

  subnet_ids       = module.vpc.public_subnets
  desired_capacity = var.cluster_desired_capacity
  max_size         = var.cluster_max_size
  min_size         = var.cluster_min_size

  security_group_ids = var.cluster_ssh_key != "" ? [aws_security_group.ecs_ssh_access[0].id] : []

  providers = {
    aws = aws
  }

}

resource "aws_security_group" "ecs_ssh_access" {
  count       = var.cluster_ssh_key != "" ? 1 : 0
  name        = "${var.cluster_name}-ssh"
  description = "admin SSH access to ecs cluster"
  vpc_id      = module.vpc.vpc_id
  ingress {
    cidr_blocks = var.cluster_ssh_cidr #tfsec:ignore:AWS008
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  tags = local.tags
}
