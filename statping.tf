# container template
data "template_file" "statping_app" {
  template = file("./templates/statping.json")
  vars = {
    app_name = var.statping_app_name
    app_image = var.statping_app_image
    aws_region = var.aws_region
    awslogs_group = var.cluster_name
  }
}

# ECS task definition
resource "aws_ecs_task_definition" "statping_app" {
  family = "statping-task"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]

//  requires_compatibilities = ["FARGATE"]
  cpu = 998
  memory = 768
  container_definitions = data.template_file.statping_app.rendered
  volume {
    name = "statping"

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
}
# ECS service
resource "aws_ecs_service" "statping_app" {
  name = var.statping_app_name
  cluster = module.ecs_cluster.ecs_cluster_name
  task_definition = aws_ecs_task_definition.statping_app.arn
  desired_count = 1
  launch_type = "EC2"
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
  tags = {
    Name = "${var.statping_app_name}-statping-ecs"
  }
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
  tags = {
    Name = "${var.statping_app_name}-ecs-tasks"
  }
}
