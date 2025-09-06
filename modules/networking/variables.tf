variable "azs" {
  description = "List of availability zones to be used"
  type        = list(string)
}

variable "env" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming resources (e.g., VPC, subnets)"
  type        = string
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "tags" {
  description = "Key-value map of tags to apply to resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
