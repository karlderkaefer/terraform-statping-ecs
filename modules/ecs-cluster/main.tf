locals {
  cluster_name = "${var.name}-${var.environment}"
  image_id     = var.image_id == "" ? data.aws_ami.default.image_id : var.image_id
}

data "aws_availability_zones" "default" {
  state = "available"
}

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name
}

data "aws_iam_policy_document" "ecs_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs-instance-role-${local.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  count = var.use_AmazonEC2ContainerServiceforEC2Role_policy ? 1 : 0

  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRole-${local.cluster_name}"
  path = "/"
  role = aws_iam_role.ecs_instance_role.name
}

module "ecs_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name    = var.name
  lc_name = "lc-${var.name}"

  image_id                     = local.image_id
  instance_type                = var.instance_type
  associate_public_ip_address  = false
  security_groups              = concat(var.security_group_ids, [aws_security_group.main.id])
  load_balancers               = var.lb_elb_ids
  key_name                     = var.instance_key_name
  recreate_asg_when_lc_changes = true

  root_block_device = [
    {
      volume_size = var.instance_volume_size
      volume_type = "gp2"
      encrypted   = true
    },
  ]

  asg_name = "asg-${var.name}"
  // on purpose we want to run in same availability zone
  vpc_zone_identifier       = [var.subnet_ids[0]]
  health_check_type         = "EC2"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity == 0 ? var.min_size : var.desired_capacity
  wait_for_capacity_timeout = 0


  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  user_data = templatefile("${path.module}/templates/user_data.sh", {
    cluster_name                = local.cluster_name,
    instance_region             = var.instance_region,
    instance_enabled_ebs_rexray = var.instance_enabled_ebs_rexray,
    instance_enabled_efs_rexray = var.instance_enabled_efs_rexray,
  })
}

resource "aws_security_group" "main" {
  name        = "asg-${local.cluster_name}"
  description = "${local.cluster_name} ASG security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "main" {
  description       = "All outbound"
  security_group_id = aws_security_group.main.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS007
}

resource "aws_security_group_rule" "ssh_access" {
  count             = var.instance_key_name != "" ? 1 : 0
  description       = "admin SSH access to ecs cluster ${local.cluster_name}"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.cluster_ssh_cidr #tfsec:ignore:AWS006
}
