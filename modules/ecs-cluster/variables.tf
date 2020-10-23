variable "name" {
  description = "The ECS cluster name this will launching instances for."
  type        = string
}

variable "environment" {
  description = "Environment tag."
  type        = string
}

variable "image_id" {
  description = "Amazon ECS-Optimized AMI."
  default     = ""
  type        = string
}

variable "instance_region" {
  description = "aws region of the instances needed for rexray"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "The instance type to use."
  type        = string
  default     = "t2.micro"
}

variable "instance_volume_size" {
  description = "size of root disk in GB"
  type        = number
  default     = 30
}

variable "instance_key_name" {
  description = "ssh key to access ec2 instance"
  type        = string
  default     = ""
}

variable "instance_enabled_rexray" {
  description = "enable rexray for manage docker volumes with ebs"
  type        = bool
  default     = true
}

variable "cluster_ssh_cidr" {
  description = "allow ssh access only from these IP's. Highly recommended to change as this is open to world by default"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "instance_enabled_ebs_rexray" {
  description = "enable rexray for manage docker volumes with ebs"
  type        = bool
  default     = true
}

variable "instance_enabled_efs_rexray" {
  description = "enable rexray for manage docker volumes with efs"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The id of the VPC to launch resources in."
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in."
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired instance count. 0 for ignoring"
  type        = number
  default     = 0
}

variable "max_size" {
  description = "Maxmimum instance count."
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Minimum instance count."
  type        = number
  default     = 1
}

variable "use_AmazonEC2ContainerServiceforEC2Role_policy" {
  description = "Attaches the AWS managed AmazonEC2ContainerServiceforEC2Role policy to the ECS instance role."
  type        = string
  default     = true
}

variable "security_group_ids" {
  description = "A list of security group ids to attach to the autoscaling group"
  type        = list(string)
  default     = []
}

variable "lb_elb_ids" {
  description = "List of id of ELB which should be attached to autoscaling group"
  type        = list(string)
  default     = []
}


