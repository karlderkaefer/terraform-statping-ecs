module "ecs_statping_http" {
  source = "./../.."

  aws_region = var.aws_region
  cluster_enable_https = false

  cluster_ssh_key = var.cluster_ssh_key
  statping_app_name = var.statping_app_name
  cluster_name = var.cluster_name
}
