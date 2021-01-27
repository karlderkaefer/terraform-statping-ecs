data "template_file" "service" {
  for_each = var.statping_services
  template = file("${path.module}/templates/provision.sh")
  vars = {
    cluster_url  = local.statping_lb,
    api_key      = var.statping_api_key
    service_json = jsonencode(each.value.json_data)
    service_name = each.value.json_data.name
  }
}

resource "null_resource" "provision" {
  for_each = var.statping_services
  triggers = {
    script = sha256(data.template_file.service[each.key].rendered)
    random = uuid()
  }
  provisioner "local-exec" {
    command     = data.template_file.service[each.key].rendered
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    aws_ecs_service.statping_app
  ]
}
