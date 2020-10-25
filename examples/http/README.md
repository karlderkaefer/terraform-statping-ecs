# Statping example with http

Running statping with http only.

## Steps

**Optional - activate ssh access**
* upload your public key as key pair
* create file `terraform.auto.tfvars`
* reference name by adding `cluster_ssh_key = "your_keypair_name"` to `terraform.auto.tfvars`

**Optional - restrict ssh access and load balancer by ip**
* get your public ip and add cdir block for ssh and lb by adding to terraform.auto.tfvars`
    ```
    cluster_ssh_cidr = ["123.123.123.123/32"]
    cluster_lb_cidr = ["123.123.123.123/32"]
    ```

**Apply example module**
```
terraform apply
> app_url = statping-load-balancer-12345678.eu-west-1.elb.amazonaws.com
```
The load balancer name will be listed as output. Use that to connect to statping UI.

**SSH Access**
you can access ec2 instance as user `ec2-user` if you enabled it by running
```
# get public from aws console
ssh ec2-user@123.123.123.123
```

## using the module

to use the module directly from git:
```
module "ecs_cluster" {
  source = "git::git@github.com:karlderkaefer/terraform-statping-ecs.git//modules/ecs-cluster?ref=v1.0.0"
  ..
}
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
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | n/a | `string` | `"eu-central-1"` | no |
| cluster\_name | Name of ecs cluster. Full cluster name consists of ${cluster\_name}-${cluster\_environment} | `string` | `"statping"` | no |
| cluster\_ssh\_cidr | allow ssh access only from these IP's. Highly recommended to change as this is open to world by default | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_ssh\_key | allow ssh access to cluster with this key | `string` | `""` | no |
| environment | n/a | `string` | `"test"` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_url | n/a |
| script | n/a |
| services | n/a |
| statping\_template | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
