# container template

locals {
  statping_template = templatefile("${path.module}/templates/statping.json", {
    app_name = var.statping_app_name
    app_image = var.statping_app_image
    app_tag = var.statping_app_image_tag
    app_configuration = jsonencode(var.statping_configuration)
    aws_region = var.aws_region
    awslogs_group = var.cluster_name
    aws_region = var.aws_region
    cluster_name = local.cluster_full_name
  })
}

//data "template_file" "statping_app" {
//  template = file("${path.module}/templates/statping.json")
//  vars = {
//    app_name = var.statping_app_name
//    app_image = var.statping_app_image
//    app_tag = var.statping_app_image_tag
//    app_configuration = var.statping_configuration
//    aws_region = var.aws_region
//    awslogs_group = var.cluster_name
//    aws_region = var.aws_region
//    cluster_name = local.cluster_full_name
//
//  }
//}

# ECS task definition
resource "aws_ecs_task_definition" "statping_app" {
  family = "statping-task"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]

//  requires_compatibilities = ["FARGATE"]
  cpu = 998
  memory = 768
//  container_definitions = data.template_file.statping_app.rendered
  container_definitions = local.statping_template
  volume {
    name = "${local.cluster_full_name}-${var.statping_app_name}"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "rexray/ebs"

      driver_opts = {
        volumetype = "gp2"
        size       = 5
      }
    }
  }
  tags = local.tags
}
# ECS service
resource "aws_ecs_service" "statping_app" {
  name = var.statping_app_name
  cluster = module.ecs_cluster.ecs_cluster_name
  task_definition = aws_ecs_task_definition.statping_app.arn
  desired_count = 1
  launch_type = "EC2"

  // we dont want to have rolling update stop the old statping container first
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true

//  launch_type = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.aws-ecs-tasks.id]
    subnets = module.vpc.private_subnets
    assign_public_ip = false
//    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.statping_app.id
    container_name = "nginx"
    container_port = 80
  }
  depends_on = [aws_alb_listener.http]
  tags = local.tags
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "aws-ecs-tasks" {
  name = "${var.statping_app_name}-ecs-tasks"
  description = "Allow inbound access from the ALB only"
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    security_groups = [aws_security_group.aws-lb.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    security_groups = [aws_security_group.aws-lb.id]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}
