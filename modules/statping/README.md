## Statping Module
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | n/a | `string` | `"eu-central-1"` | no |
| cluster\_enable\_https | enabled and force https for ALB | `bool` | `true` | no |
| cluster\_environment | n/a | `string` | `"test"` | no |
| cluster\_hosted\_zone\_name | name of hosted zone | `string` | `""` | no |
| cluster\_instance\_type | ec2 type of nodes | `string` | `"t2.small"` | no |
| cluster\_lb\_cidr | allow access to load balancer from these IP's. By default open to world. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_name | name of ecs cluster. | `string` | n/a | yes |
| cluster\_private\_subnets | subnets for running instances. | `list(string)` | n/a | yes |
| cluster\_public\_subnets | subnets for load balancer. | `list(string)` | n/a | yes |
| cluster\_ssh\_cidr | allow ssh access only from these IP's. Highly recommended to change as this is open to world by default | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_ssh\_key | allow ssh access to cluster with this key | `string` | `""` | no |
| cluster\_vpc\_id | vpc id for ecs service and ecs cluster | `string` | n/a | yes |
| nginx\_cpu | cpu for nginx container in ms | `number` | `32` | no |
| nginx\_memory | memory for nginx container in MB | `number` | `128` | no |
| statping\_api\_key | api key to be able to provision statping | `string` | `""` | no |
| statping\_app\_image | Docker image to run in the ECS cluster | `string` | `"statping/statping"` | no |
| statping\_app\_image\_tag | Docker tag for statping | `string` | `"v0.90.71"` | no |
| statping\_app\_name | Name of Application Container | `string` | `"statping"` | no |
| statping\_configuration | configuration of statping with environment variable. Get full list at https://github.com/statping/statping/blob/dev/utils/env.go | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "DB_CONN",<br>    "value": "sqlite"<br>  },<br>  {<br>    "name": "USE_ASSESTS",<br>    "value": "true"<br>  }<br>]</pre> | no |
| statping\_cpu | cpu for statping container in ms | `number` | `256` | no |
| statping\_domain | name of the domain where statping should be reachable | `string` | `""` | no |
| statping\_memory | memory for statping container in MB | `number` | `256` | no |
| statping\_services | service list to provision | <pre>map(object({<br>    json_data = object({<br>      name            = string<br>      domain          = string<br>      expected        = string<br>      expected_status = number<br>      check_interval  = number<br>      type            = string<br>      method          = string<br>      post_data       = string<br>      port            = number<br>      timeout         = number<br>      order_id        = number<br>    })<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| script | n/a |
| services | n/a |
| statping\_configuration | environment variables for statping |
| statping\_dns\_lb | DNS load balancer |
| statping\_template | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
