# Terraform Statping

## FAQ

You have have to [enable new ARN format for your account](https://aws.amazon.com/blogs/compute/migrating-your-amazon-ecs-deployment-to-the-new-arn-and-resource-id-format-2/). Note this settings depend on region. Otherwise you get this exception
```
Error: InvalidParameterException: The new ARN and resource ID format must be enabled to add tags to the service. Opt in to the new format and try again. "statping"
```
[](https://d2908q01vomqb2.cloudfront.net/1b6453892473a467d07372d45eb05abc2031647a/2018/10/29/turn-on-new-arn-format.png)
