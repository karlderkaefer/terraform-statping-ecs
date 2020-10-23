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
