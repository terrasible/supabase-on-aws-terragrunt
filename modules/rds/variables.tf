###################################
# Variables
###################################
variable "backup_retention" {
  description = "The days to retain backups for"
  type        = number
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "database_subnets" {
  description = "List of database subnet IDs where RDS will be deployed"
  type        = list(string)
}

variable "db_allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = number
}

variable "db_engine_version" {
  description = "Version number of the database engine"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "db_max_storage" {
  description = "The upper limit of scalable storage in gibibytes"
  type        = number
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "family" {
  description = "The family of the DB instance"
  type        = string
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:05:00-Mon:06:00"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where RDS will be deployed"
  type        = string
}
