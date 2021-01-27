variable "aws_region" {
  default = "eu-central-1"
  type    = string
}

variable "cluster_vpc_id" {
  description = "vpc id for ecs service and ecs cluster"
  type        = string
}

variable "cluster_ssh_key" {
  description = "allow ssh access to cluster with this key"
  default     = ""
  type        = string
}

variable "cluster_environment" {
  default = "test"
  type    = string
}

variable "cluster_name" {
  description = "name of ecs cluster."
  type        = string
}

variable "cluster_ssh_cidr" {
  description = "allow ssh access only from these IP's. Highly recommended to change as this is open to world by default"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "cluster_lb_cidr" {
  description = "allow access to load balancer from these IP's. By default open to world."
  default     = ["0.0.0.0/0"]
  type        = list(string)
}


variable "cluster_instance_type" {
  description = "ec2 type of nodes"
  default     = "t2.small"
  type        = string
}

variable "cluster_enable_https" {
  description = "enabled and force https for ALB"
  default     = true
  type        = bool
}

variable "cluster_hosted_zone_name" {
  description = "name of hosted zone"
  default     = ""
  type        = string
}

variable "cluster_private_subnets" {
  description = "subnets for running instances."
  type        = list(string)
}

variable "cluster_public_subnets" {
  description = "subnets for load balancer."
  type        = list(string)
}

variable "statping_app_name" {
  description = "Name of Application Container"
  default     = "statping"
  type        = string
}

variable "statping_app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "statping/statping"
  type        = string
}

variable "statping_app_image_tag" {
  description = "Docker tag for statping"
  default     = "v0.90.71"
  type        = string
}

variable "statping_configuration" {
  description = "configuration of statping with environment variable. Get full list at https://github.com/statping/statping/blob/dev/utils/env.go"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "DB_CONN"
      value = "sqlite"
    },
    {
      name  = "USE_ASSESTS"
      value = "true"
    }
  ]
}

variable "statping_domain" {
  description = "name of the domain where statping should be reachable"
  default     = ""
  type        = string
}

variable "statping_api_key" {
  description = "api key to be able to provision statping"
  default     = ""
  type        = string
}

variable "statping_services" {
  description = "service list to provision"
  type = map(object({
    json_data = object({
      name            = string
      domain          = string
      expected        = string
      expected_status = number
      check_interval  = number
      type            = string
      method          = string
      post_data       = string
      port            = number
      timeout         = number
      order_id        = number
    })
  }))
  default = {}
}

variable "nginx_cpu" {
  description = "cpu for nginx container in ms"
  type        = number
  default     = 32
}

variable "nginx_memory" {
  description = "memory for nginx container in MB"
  type        = number
  default     = 128
}

variable "statping_cpu" {
  description = "cpu for statping container in ms"
  type        = number
  default     = 256
}

variable "statping_memory" {
  description = "memory for statping container in MB"
  type        = number
  default     = 256
}


