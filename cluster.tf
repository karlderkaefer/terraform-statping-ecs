module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  name        = var.cluster_name
  environment = var.cluster_environment

  vpc_id = module.vpc.vpc_id

  image_id      = data.aws_ami.default.image_id
  instance_type = var.cluster_instance_type
  instance_key_name = "karl"

  subnet_ids       = module.vpc.public_subnets
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  security_group_ids = [aws_security_group.ecs_ssh_access.id]

}

resource "aws_security_group" "ecs_ssh_access" {
  name = "${var.cluster_name}-ssh"
  description = "admin SSH access to ecs cluster"
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = var.cluster_ssh_cidr
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
}
