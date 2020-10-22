data "aws_iam_policy_document" "task-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.cluster_name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.task-assume-role.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
