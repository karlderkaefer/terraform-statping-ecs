variable "aws_region" {
  default = "eu-central-1"
  type    = string
}

variable "cluster_ssh_key" {
  description = "allow ssh access to cluster with this key"
  default     = ""
  type        = string
}

variable "cluster_name" {
  description = "Name of ecs cluster. Full cluster name consists of $${cluster_name}-$${cluster_environment} "
  default     = "statping"
  type        = string
}

variable "environment" {
  default = "test"
  type    = string
}

variable "cluster_ssh_cidr" {
  description = "allow ssh access only from these IP's. Highly recommended to change as this is open to world by default"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "cluster_lb_cidr" {
  default = ["0.0.0.0/0"]
  type    = list(string)
}

variable "cluster_hosted_zone_name" {
  default = ""
  type    = string
}

variable "statping_domain" {
  default = ""
  type    = string
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

variable "instance_type" {
  description = "The instance type to use."
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Desired instance count. 0 for ignoring"
  type        = number
  default     = 0
}

