locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load environment-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out serving variables for reuse
  env         = local.env_vars.locals.env
  name_prefix = local.env_vars.locals.name_prefix
  region      = local.region_vars.locals.region
  zones       = local.region_vars.locals.zones
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_path_to_repo_root()}//modules/networking"
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix = local.name_prefix

  env      = local.env
  vpc_cidr = "10.0.0.0/16"
  azs      = local.zones

  private_subnets  = ["10.0.0.0/22", "10.0.4.0/22"]     # Compute (EKS)
  database_subnets = ["10.0.50.0/24", "10.0.51.0/24"]   # Storage (DocDB)
  public_subnets   = ["10.0.100.0/24", "10.0.101.0/24"] # Internet Gateway

  tags = {
    component = "networking"
    env       = local.env
  }
}
