module "ecs_statping_http" {
  source = "./../.."

  aws_region = "eu-west-1"
  cluster_enable_https = false

  cluster_ssh_key = "some_key"
  statping_app_name = "statping2"
  cluster_name = "statping-example-http"
}
