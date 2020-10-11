variable "aws_region" {
  default = "eu-central-1"
  type = string
}

variable "cluster_ssh_key" {
  description = "allow ssh access to cluster with this key"
  default = ""
  type = string
}

variable "cluster_environment" {
  default = "test"
  type = string
}

variable "cluster_name" {
  description = "Name of ecs cluster. Full cluster name consists of $${cluster_name}-$${cluster_environment} "
  default = "statping"
  type = string
}

variable "cluster_ssh_cidr" {
  description = "allow ssh access only from these IP's. Highly recommended to change as this is open to world by default"
  default = ["0.0.0.0/0"]
  type = list(string)
}

variable "cluster_lb_cidr" {
  description = "allow access to load balancer from these IP's. By default open to world."
  default = ["0.0.0.0/0"]
  type = list(string)
}

variable "cluster_instance_type" {
  description = "ec2 type of nodes"
  default = "t2.small"
  type = string
}

variable "cluster_desired_capacity" {
  description = "desired number of nodes of cluster"
  default = 1
  type = number
}

variable "cluster_min_size" {
  description = "minimum number of nodes of cluster"
  default = 1
  type = number
}

variable "cluster_max_size" {
  description = "maximum number of nodes of cluster"
  default = 3
  type = number
}

variable "cluster_enable_https" {
  description = "enabled and force https for ALB"
  default = true
  type = bool
}

variable "cluster_hosted_zone_name" {
  description = "name of hosted zone"
  default = ""
  type = string
}

variable "statping_app_name" {
  description = "Name of Application Container"
  default = "statping"
  type = string
}

variable "statping_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "statping/statping"
  type = string
}

variable "statping_app_image_tag" {
  description = "Docker tag for statping"
  default = "v0.90.69"
  type = string
}

variable "statping_configuration" {
  description = "configuration of statping with environment variable. Get full list at https://github.com/statping/statping/blob/dev/utils/env.go"
  type = list(object({
    name = string
    value = string
  }))
  default = [
    {
      name = "DB_CONN"
      value = "sqlite"
    },
    {
      name = "USE_ASSESTS"
      value = "true"
    }
  ]
}

variable "statping_domain" {
  description = "name of the domain where statping should be reachable"
  default = ""
  type = string
}
