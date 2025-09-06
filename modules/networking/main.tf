resource "random_id" "vpc_suffix" {
  byte_length = 3
}

#-----------------------------------------------------------------------------------
# EIPs created externally to persist IPs across VPC destruction/recreation cycles
#-----------------------------------------------------------------------------------

resource "aws_eip" "nat_ip" {
  count  = 1
  domain = "vpc"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  #trivy:ignore:avd-aws-0102
  #trivy:ignore:aws-ec2-1

  name = "${var.name_prefix}-${var.env}-vpc-${random_id.vpc_suffix.hex}"

  cidr = var.vpc_cidr

  azs = var.azs

  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
  public_subnets   = var.public_subnets

  # TODO: To Sample down the flow logs if cost will be a problem, not controlled by this module

  enable_flow_log                           = true
  create_flow_log_cloudwatch_log_group      = true
  create_flow_log_cloudwatch_iam_role       = true
  flow_log_max_aggregation_interval         = 60
  flow_log_cloudwatch_log_group_name_prefix = "/aws/${var.name_prefix}-${var.env}/"
  flow_log_cloudwatch_log_group_name_suffix = "flow-logs"
  flow_log_cloudwatch_log_group_class       = "INFREQUENT_ACCESS"

  #------------------------------------------------------------------------------------------------------
  # Cost of 12 Interface endpoints is approx 86.40$ per month. (0.01*12*720)
  # For now we will use NAT gateway with static cost of approx 38$ per month and later on switch to interface endponts
  #------------------------------------------------------------------------------------------------------

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  reuse_nat_ips       = true                # Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat_ip.*.id # NAT IPs created outside the module

  tags = var.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.19.0"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "vpc-endpoints-"
  security_group_description = "VPC endpoint security group"

  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    # S3 VPC Endpoint no upfront cost only usage cost
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      private_dns_enabled = true
      route_table_ids = flatten([
        module.vpc.private_route_table_ids,
        module.vpc.database_route_table_ids
      ])
      tags = { name = "${var.name_prefix}-${var.env}-s3-endpoint-${random_id.vpc_suffix.hex}" }
    }

    # DynamoDB VPC Endpoint no upfront cost only usage cost
    # - Uses a "Gateway" endpoint, which requires a manual route table entry.
    # - The route table entry ensures private access to DynamoDB without a NAT Gateway.
    dynamodb = {
      service      = "dynamodb"
      service_type = "Gateway"
      route_table_ids = flatten([
        module.vpc.private_route_table_ids,
        module.vpc.database_route_table_ids
      ])
      tags = { name = "${var.name_prefix}-${var.env}-dynamodb-vpc-endpoint-${random_id.vpc_suffix.hex}" }
    }
  }
}
