###################################
# Outputs
###################################
output "db_endpoint" {
  value = module.rds_postgres.db_instance_address
}

output "db_password_parameter" {
  value = aws_ssm_parameter.db_password.name
}

output "db_password" {
  description = "Database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "db_instance_address" {
  value = module.rds_postgres.db_instance_address
}

output "db_instance_arn" {
  value = module.rds_postgres.db_instance_arn
}

output "db_secretmanager_arn" {
  description = "Database secret manager ARN"
  value       = module.rds_postgres.db_instance_master_user_secret_arn
}

output "db_username" {
  description = "Database username"
  value       = var.db_username
}

output "db_name" {
  description = "The name of the database"
  value       = "${var.name_prefix}${var.env}db"
}

output "db_security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.rds.id
}

output "db_instance_port" {
  description = "Database instance port"
  value       = module.rds_postgres.db_instance_port
}

output "rds_secretmanager_arn" {
  description = "RDS Secret manager secret ARN"
  value       = module.rds_postgres.db_instance_master_user_secret_arn
}
