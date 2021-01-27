# container template

//resource "aws_efs_file_system" "efs" {
//  encrypted = true
//}

# ECS task definition
resource "aws_ecs_task_definition" "statping_app" {

  family                   = "statping-task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  //  requires_compatibilities = ["FARGATE"]
  cpu                   = var.statping_cpu + var.nginx_cpu
  memory                = var.statping_memory + var.nginx_memory
  container_definitions = local.statping_template
  volume {
    name = "${local.cluster_full_name}-${var.statping_app_name}"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "rexray/ebs"
      //      driver        = "rexray/efs"
      driver_opts = {
        volumetype = "gp2"
        size       = 10
      }
    }
  }
  tags = local.tags
}
# ECS service
resource "aws_ecs_service" "statping_app" {
  name            = var.statping_app_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.statping_app.arn
  desired_count   = 1
  launch_type     = "EC2"
  //  launch_type     = "FARGATE"
  //  capacity_provider_strategy {
  //    capacity_provider = ""
  //  }
  //  deployment_minimum_healthy_percent = 0
  //  deployment_maximum_percent = 100

  network_configuration {
    security_groups = [aws_security_group.aws-ecs-tasks.id]
    # we want to run in single AZ for persistent volumes
    subnets          = var.cluster_private_subnets
    assign_public_ip = false
    //        assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.statping_app.id
    container_name   = "nginx"
    container_port   = 80
  }
  depends_on = [aws_alb_listener.http]
  tags       = local.tags
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "aws-ecs-tasks" {
  name        = "${var.statping_app_name}-ecs-tasks"
  description = "Allow inbound access from the ALB only"
  vpc_id      = var.cluster_vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.aws-lb.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.aws-lb.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }
  tags = local.tags
  depends_on = [
    aws_alb_listener.http,
    aws_alb_listener.https,
    aws_lb_listener.http_redirect
  ]
}
