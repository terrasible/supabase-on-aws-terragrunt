<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.19.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [random_id.vpc_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of availability zones to be used | `list(string)` | n/a | yes |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of CIDR blocks for database subnets | `list(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The deployment environment (e.g., dev, staging, prod) | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used for naming resources (e.g., VPC, subnets) | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of CIDR blocks for the database subnets |
| <a name="output_database_subnets_ids"></a> [database\_subnets\_ids](#output\_database\_subnets\_ids) | List of IDs of the database subnets |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the default security group for the VPC |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of CIDR blocks for the private subnets |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | List of IDs of the private subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of CIDR blocks for the public subnets |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | List of IDs of the public subnets |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
