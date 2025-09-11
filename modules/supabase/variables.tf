###################################
# General Configuration
###################################
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

###################################
# EKS Cluster Configuration
###################################
variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  type        = string
}


variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

###################################
# Database Configuration
###################################
variable "db_host" {
  description = "RDS PostgreSQL endpoint"
  type        = string
}

variable "db_port" {
  description = "RDS PostgreSQL port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name"
  type        = string
}

###################################
# Secrets Manager Configuration
###################################
variable "db_secretmanager_arn" {
  description = "ARN of the AWS Secrets Manager secret containing database credentials"
  type        = string
  default     = null
}

###################################
# Networking Configuration
###################################
variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

###################################
# Supabase Configuration
###################################

variable "domain_name" {
  description = "Domain for Supabase API"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the existing S3 bucket for Supabase storage"
  type        = string
}

variable "smtp_username" {
  description = "SMTP username for email notifications"
  type        = string
}

variable "dashboard_username" {
  description = "Username for Supabase studio console"
  type        = string
}
