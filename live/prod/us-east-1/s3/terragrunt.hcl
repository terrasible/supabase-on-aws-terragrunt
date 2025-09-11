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
  account_id                              = local.account_vars.locals.account_id
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v5.7.0"
}

# Include all settings from the root terragrunt.hcl file
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  bucket_prefix = "${local.name_prefix}-storage-${local.env}"

  acl           = "private"
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  # Security
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Versioning
  versioning = {
    enabled = true
  }

  # Encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }

  # IAM Policy will be configured separately after the Supabase role is created
  attach_policy = false

  tags = {
    component = "s3"
    env       = local.env
  }
}
