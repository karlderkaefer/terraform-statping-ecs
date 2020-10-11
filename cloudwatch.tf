resource "aws_cloudwatch_log_group" "statping" {
  name              = var.cluster_name
  retention_in_days = 7
  tags              = local.tags
}
