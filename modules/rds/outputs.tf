###################################
# Outputs
###################################
output "db_endpoint" {
  value = module.rds_postgres.db_instance_address
}

output "db_password_parameter" {
  value = aws_ssm_parameter.db_password.name
}

output "db_instance_address" {
  value = module.rds_postgres.db_instance_address
}

output "db_instance_arn" {
  value = module.rds_postgres.db_instance_arn
}
