locals {
  tags = {
    Environment = var.cluster_environment
    App         = var.cluster_name
    ManagedBy   = "terraform"
  }
  cluster_full_name = "${var.cluster_name}-${var.cluster_environment}"
  statping_template = templatefile("${path.module}/templates/statping.json", {
    app_name          = var.statping_app_name
    app_image         = var.statping_app_image
    app_tag           = var.statping_app_image_tag
    app_configuration = jsonencode(var.statping_configuration)
    aws_region        = var.aws_region
    awslogs_group     = aws_cloudwatch_log_group.statping.name
    aws_region        = var.aws_region
    cluster_name      = local.cluster_full_name
  })
  statping_lb = var.cluster_enable_https ? format("%s://%s", "https", var.statping_domain) : format("%s://%s", "http", aws_alb.main.dns_name)
}
