variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region where the EKS cluster will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for security group rules"
  type        = string
}
