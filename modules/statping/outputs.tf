output "statping_dns_lb" {
  description = "DNS load balancer"
  value       = var.cluster_enable_https ? var.statping_domain : aws_alb.main.dns_name
}

output "statping_template" {
  value = local.statping_template
}

output "statping_configuration" {
  description = "environment variables for statping"
  value       = var.statping_configuration
}

