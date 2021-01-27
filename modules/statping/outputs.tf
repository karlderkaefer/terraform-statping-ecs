output "statping_dns_lb" {
  description = "DNS load balancer"
  value       = local.statping_lb
}

output "statping_template" {
  value = local.statping_template
}

output "statping_configuration" {
  description = "environment variables for statping"
  value       = var.statping_configuration
}

output "services" {
  value = var.statping_services
}

