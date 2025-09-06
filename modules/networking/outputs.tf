output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "List of IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets_ids" {
  description = "List of IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets_ids" {
  description = "List of IDs of the database subnets"
  value       = module.vpc.database_subnets
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks for the private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks for the database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "default_security_group_id" {
  description = "The ID of the default security group for the VPC"
  value       = module.vpc.default_security_group_id
}

# output "vpc_main_route_table_id" {
#   description = "The ID of the main route table associated with the VPC"
#   value       = module.vpc.vpc_main_route_table_id
# }
#
# output "public_route_table_ids" {
#   description = "List of IDs of the public route tables"
#   value       = module.vpc.public_route_table_ids
# }
#
# output "private_route_table_ids" {
#   description = "List of IDs of the private route tables"
#   value       = module.vpc.private_route_table_ids
# }
#
# output "database_route_table_ids" {
#   description = "List of IDs of the storage route tables"
#   value       = module.vpc.database_route_table_ids
# }
