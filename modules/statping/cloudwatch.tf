resource "aws_cloudwatch_log_group" "statping" {
  name              = local.cluster_full_name
  retention_in_days = 7
  tags              = local.tags
}
