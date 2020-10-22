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
