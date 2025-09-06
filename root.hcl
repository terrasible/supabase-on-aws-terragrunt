# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_id         = local.account_vars.locals.account_id
  account_name       = local.account_vars.locals.account_name
  remote_bucket_name = local.account_vars.locals.remote_bucket_name
  region             = local.region_vars.locals.region
  zones              = local.region_vars.locals.zones
  env                = local.env_vars.locals.env
  name_prefix        = local.env_vars.locals.name_prefix
}

terraform {
  # Speed up terragrunt operations
  before_hook "ensure_init" {
    commands = ["apply", "plan", "destroy"]
    execute  = ["terraform", "init", "-upgrade=false"]
  }

  # Performance optimizations for all operations
  extra_arguments "optimization" {
    commands = ["init", "apply", "plan", "destroy"]
    arguments = [
      //"-parallelism=4",
      //"-refresh=true",
      "-no-color"
    ]
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  allowed_account_ids = ["${local.account_id}"]

  # Add security best practices
  default_tags {
    tags = {
      CreatedBy   = "terragrunt"
      ManagedBy   = "terrasible"
    }
  }
}
EOF
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    region         = local.region
    bucket         = "${local.remote_bucket_name}-${local.account_name}-${local.region}"
    key            = "${local.account_name}/${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "tf-locks-${local.account_name}-${local.region}"
    encrypt        = true
    acl            = "private"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.env_vars.locals,
)
