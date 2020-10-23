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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
