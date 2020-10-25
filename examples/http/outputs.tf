output "app_url" {
  value = module.ecs_statping.statping_dns_lb
}

output "statping_template" {
  value = module.ecs_statping.statping_configuration
}

output "script" {
  value = module.ecs_statping.script
}
output "services" {
  value = module.ecs_statping.services
}
