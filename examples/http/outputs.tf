output "app_url" {
  value = module.ecs_statping_http.statping_dns_lb
}

output "statping_configuration" {
  value = var.statping_configuration
}

//output "statping_template" {
//  value = module.ecs_statping_http.statping_template
//}
