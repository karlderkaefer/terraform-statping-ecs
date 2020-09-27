output "statping_dns_lb" {
  description = "DNS load balancer"
  value = var.cluster_enable_https ? var.statping_domain : aws_alb.main.dns_name
}
