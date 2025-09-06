###################################
# Random Password for DB
###################################
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

###################################
# Store DB Password in SSM
###################################
resource "aws_ssm_parameter" "db_password" {
  name        = "/rds/${var.env}/db_password"
  description = "RDS PostgreSQL password for ${var.env}"
  type        = "SecureString"
  value       = random_password.db_password.result
  overwrite   = true
}

###################################
# KMS Key for RDS Encryption
###################################
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS PostgreSQL encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "rds_alias" {
  name          = "alias/${var.name_prefix}-${var.env}-rds-key"
  target_key_id = aws_kms_key.rds.key_id
}

###################################
# Security Group for RDS
###################################
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-${var.env}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

###################################
# RDS PostgreSQL Instance
###################################
#trivy:ignore:AVD-AWS-0177:This is enable for clean destruction of RDS instance
module "rds_postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.12"

  identifier = "${var.name_prefix}-${var.env}-postgres-instance"
  db_name    = "${var.name_prefix}${var.env}db"

  engine                = "postgres"
  engine_version        = var.db_engine_version
  family                = var.family
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_storage

  iam_database_authentication_enabled = true

  multi_az            = true
  storage_encrypted   = true
  kms_key_id          = aws_kms_key.rds.arn
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.rds.id]
  create_db_subnet_group = true
  db_subnet_group_name   = "${var.name_prefix}-${var.env}-db-subnet-group"
  subnet_ids             = var.database_subnets

  username = var.db_username
  password = random_password.db_password.result

  backup_retention_period         = var.backup_retention
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  deletion_protection = false

  monitoring_interval    = 60
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = var.tags
}
