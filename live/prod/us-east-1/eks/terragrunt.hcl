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
  source = "${get_path_to_repo_root()}//modules/eks"
}

dependency "networking" {
  config_path = "${get_parent_terragrunt_dir()}/live/${local.env}/${local.region}/networking"
  mock_outputs = {
    vpc_id              = "vpc-hgygjj"
    private_subnets_ids = ["subnet-hhhh", "subnet-05b96e1d14234e245"]
  }
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix = local.name_prefix
  env         = local.env
  region      = local.region

  vpc_id          = dependency.networking.outputs.vpc_id
  private_subnets = dependency.networking.outputs.private_subnets_ids

  tags = {
    component = "networking"
    env       = local.env
  }
}
