locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load environment-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out serving variables for reuse
  env                                     = local.env_vars.locals.env
  name_prefix                             = local.env_vars.locals.name_prefix
  region                                  = local.region_vars.locals.region
  zones                                   = local.region_vars.locals.zones
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_path_to_repo_root()}//modules/supabase"
}

# Dependencies on other infrastructure components
dependency "networking" {
  config_path = "${get_parent_terragrunt_dir()}/live/${local.env}/${local.region}/networking"
  mock_outputs = {
    vpc_id              = "vpc-0a1b2c3d4e5f6g7h8"
    private_subnets_ids = ["subnet-012feac531c224e6d", "subnet-05b96e1d14234e245"]
    vpc_cidr_block      = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands
}

dependency "eks" {
  config_path = "${get_parent_terragrunt_dir()}/live/${local.env}/${local.region}/eks"
  mock_outputs = {
    cluster_name           = "mock-cluster"
    cluster_endpoint       = "https://mock-endpoint.eks.us-east-1.amazonaws.com"
    cluster_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJQ21jN3doQjVocHN3RFFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM3MFhKTDJwakVJalVYNnA1cndoMjhESDlaZXNpWE1zSTV2L1orNloxRkNZRFp5aWdETlZqNzVVR3kKYmVvbE1KQnIyaWQ3T09FNGJSaG03czdpWlJqM21KNmYvbWRHcnhnanJRcjJudGEzTjdpazhpU1laZmpkbVZ6SQpMZGdYUk9ZSWR2eWIyUEM0MjNkcFRWK3lsUkNvNUdtckdDN2w5c0hmcy9ESUhjVmhVSmV5Z3hVYyszVmVrTTdjCnJhbkxDcFFsWFMxaWN2MnRDZnVBWFYvaTJyMldNcnF1blpzbitBQ2VLN1dZdmdyOHpZTXB3aGU2Wi82cWFwdUEKRURLMVQ0VlRhMGJKZlJPSUdyUUMweXF2R3ZjblU0UjhuUmtkMzliYU9GcWZlaEE5SC8weW1QWGVkbVhFaVN5Tgp3VmJXUk1hV1M3dEJwTlA5bEtYclhYNmUvN0xyQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRVW5wK1F3cDloY2trMTgrbHFSS3FKYmZ2VUFUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQWNGNmJZVWVsRgpZSzVFQjlCQ3NLdHlvV00wTUI4Yzh1THE1ZisvbEZvY2dwNFVRSmx3K3BpRDlCRnRnSGRQOXFYZjRtNTVJTHF3Ck90RUtmYUxRY3IyaXY0bElrb1ZGMTZUR2V2V1p6czhuK05xZFEyOXB1UWxPam1Ld3hrb0NPUlpHbG4zTWU1SnEKa2J1cHZTdXE5TElTR2ZjOGUwbmFqKzBVT0FyeTNjRDRMTjJKUTFQY2ViYVhiUnNxc1B4bHZDQVBMaThTRi8yVApTaWt5VHQxeklmS09KWkNuU0RHd2VUeFNBSjlTZUZuMmUvWFdVZWRmR3ZUOUhJb3FXUk9sb3RUYmlZV0xwVE0xCkYyNERHQmJYTXFraFo1ZEhkalFUa3hjNklRaXNKSmliU0g4ZzQ3eHluaEZOTjZHT2NXVGU5WXJxLzZObVA4UGgKaWVydGIxVXQ5ay9DCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
    oidc_provider_arn      = "arn:aws:iam::6754ew465w8846w:oidc-provider/oidc.eks.us-east-6.amazonaws.com/id/vckvbfxkbvgkxbfk"
  }
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands
}

dependency "rds" {
  config_path = "${get_parent_terragrunt_dir()}/live/${local.env}/${local.region}/rds"
  mock_outputs = {
    db_instance_address                = "mock-db.cluster-xyz.us-east-1.rds.amazonaws.com"
    db_instance_master_user_secret_arn = "arn:aws:rds:us-east-1:123456789012:pwd:mock-db-pwd"
    dashboard_username                 = "mock-db-name"
    db_instance_port                   = 5432
    db_name                            = "mock-db-name"
    db_username                        = "mock-username"
    db_password_parameter              = "mock-password-123" #gitleaks:allow

  }
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands
}

dependency "s3" {
  config_path = "${get_parent_terragrunt_dir()}/live/${local.env}/${local.region}/s3"
  mock_outputs = {
    s3_bucket_id = "mock-storage-bucket"
  }
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # General Configuration
  name_prefix = local.name_prefix
  env         = local.env
  region      = local.region
  account_id  = local.account_vars.locals.account_id

  # EKS Cluster Configuration
  cluster_name           = dependency.eks.outputs.cluster_name
  cluster_endpoint       = dependency.eks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.eks.outputs.cluster_ca_certificate

  # Database Configuration
  db_host              = dependency.rds.outputs.db_instance_address
  db_port              = dependency.rds.outputs.db_instance_port
  db_name              = dependency.rds.outputs.db_name
  db_secretmanager_arn = dependency.rds.outputs.rds_secretmanager_arn

  # Networking Configuration
  vpc_id             = dependency.networking.outputs.vpc_id
  private_subnet_ids = dependency.networking.outputs.private_subnets_ids
  vpc_cidr           = dependency.networking.outputs.vpc_cidr_block

  # Supabase Configuration
  domain_name = "terrasible.com"

  # Storage Configuration
  s3_bucket_name = dependency.s3.outputs.s3_bucket_id

  # SMTP Configuration
  smtp_username      = "admin@terrasible.com"
  dashboard_username = "supabase"

  tags = {
    component = "supabase"
    env       = local.env
  }
}
