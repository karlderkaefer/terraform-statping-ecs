## ECS cluster
modified from https://github.com/trussworks/terraform-aws-ecs-cluster
* added EBS docker plugin for ECS

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_ssh\_cidr | allow ssh access only from these IP's. Highly recommended to change as this is open to world by default | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| desired\_capacity | Desired instance count. 0 for ignoring | `number` | `0` | no |
| environment | Environment tag. | `string` | n/a | yes |
| image\_id | Amazon ECS-Optimized AMI. | `string` | `""` | no |
| instance\_enabled\_ebs\_rexray | enable rexray for manage docker volumes with ebs | `bool` | `true` | no |
| instance\_enabled\_efs\_rexray | enable rexray for manage docker volumes with efs | `bool` | `false` | no |
| instance\_enabled\_rexray | enable rexray for manage docker volumes with ebs | `bool` | `true` | no |
| instance\_key\_name | ssh key to access ec2 instance | `string` | `""` | no |
| instance\_region | aws region of the instances needed for rexray | `string` | `"eu-central-1"` | no |
| instance\_type | The instance type to use. | `string` | `"t2.micro"` | no |
| instance\_volume\_size | size of root disk in GB | `number` | `30` | no |
| lb\_elb\_ids | List of id of ELB which should be attached to autoscaling group | `list(string)` | `[]` | no |
| max\_size | Maxmimum instance count. | `number` | `5` | no |
| min\_size | Minimum instance count. | `number` | `1` | no |
| name | The ECS cluster name this will launching instances for. | `string` | n/a | yes |
| security\_group\_ids | A list of security group ids to attach to the autoscaling group | `list(string)` | `[]` | no |
| subnet\_ids | A list of subnet IDs to launch resources in. | `list(string)` | n/a | yes |
| use\_AmazonEC2ContainerServiceforEC2Role\_policy | Attaches the AWS managed AmazonEC2ContainerServiceforEC2Role policy to the ECS instance role. | `string` | `true` | no |
| vpc\_id | The id of the VPC to launch resources in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ecs\_cluster\_arn | The ARN of the ECS cluster. |
| ecs\_cluster\_name | The name of the ECS cluster. |
| ecs\_instance\_role | The name of the ECS instance role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
