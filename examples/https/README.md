## Statping with AWS ACM certificate

create your variables 
```
cat <<EOF >>terraform.auto.tfvars
# required
aws_region      = "eu-west-1"

cluster_name    = "statping-staging"

# optional
# cluster_ssh_key = "karl"
# optional
# cluster_ssh_cidr         = ["123.123.123.123/32"]

# you can limit access to statping by your own IP
cluster_lb_cidr          = ["123.123.123.123/32"]

# required for https your aws hosted zone
cluster_hosted_zone_name = "yourdomain.com"
# statping will reachable here
statping_domain          = "statping-staging.yourdomain.com""
EOF
```
then provision statping with terraform. After 6min you statping_domain should be reachable.
```
terraform init
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | n/a | `string` | `"eu-central-1"` | no |
| cluster\_hosted\_zone\_name | n/a | `string` | `""` | no |
| cluster\_lb\_cidr | n/a | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_name | Name of ecs cluster. Full cluster name consists of ${cluster\_name}-${cluster\_environment} | `string` | `"statping"` | no |
| cluster\_ssh\_cidr | allow ssh access only from these IP's. Highly recommended to change as this is open to world by default | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_ssh\_key | allow ssh access to cluster with this key | `string` | `""` | no |
| environment | n/a | `string` | `"test"` | no |
| statping\_domain | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_url | n/a |
| statping\_template | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
