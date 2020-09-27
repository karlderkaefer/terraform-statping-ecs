variable "aws_region" {
  default = "eu-central-1"
  type = string
}

variable "aws_key_name" {
  default = ""
  type = string
}

variable "cluster_environment" {
  default = "test"
  type = string
}

variable "cluster_name" {
  default = "statping"
  type = string
}

variable "cluster_ssh_cidr" {
  default = ""
  type = string
}

variable "cluster_instance_type" {
  default = "t2.small"
  type = string
}

variable "cluster_node_count" {
  default = 1
  type = number
}

variable "cluster_enable_https" {
  description = "enabled and force https for ALB"
  default = true
}

variable "cluster_hosted_zone_name" {
  description = "name of hosted zone"
  default = ""
}

variable "statping_app_name" {
  description = "Name of Application Container"
  default = "statping"
}

variable "statping_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "statping/statping:latest"
}

variable "statping_domain" {
  description = "name of the domain where statping should be reachable"
  default = ""
}
