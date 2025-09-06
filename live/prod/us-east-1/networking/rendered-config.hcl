locals {
  region_vars = {
    dependencies                 = null
    download_dir                 = ""
    generate                     = {}
    iam_assume_role_duration     = null
    iam_assume_role_session_name = ""
    iam_role                     = ""
    iam_web_identity_token       = ""
    inputs                       = null
    locals = {
      region = "us-east-1"
      zones  = ["us-east-1a", "us-east-1b"]
    }
    retry_max_attempts            = null
    retry_sleep_interval_sec      = null
    retryable_errors              = null
    terraform_binary              = ""
    terraform_version_constraint  = ""
    terragrunt_version_constraint = ""
  }
  zones = ["us-east-1a", "us-east-1b"]
  account_vars = {
    dependencies                 = null
    download_dir                 = ""
    generate                     = {}
    iam_assume_role_duration     = null
    iam_assume_role_session_name = ""
    iam_role                     = ""
    iam_web_identity_token       = ""
    inputs                       = null
    locals = {
      account_id         = "688567272993"
      account_name       = "prod"
      remote_bucket_name = "supabase-infra-backend"
    }
    retry_max_attempts            = null
    retry_sleep_interval_sec      = null
    retryable_errors              = null
    terraform_binary              = ""
    terraform_version_constraint  = ""
    terragrunt_version_constraint = ""
  }
  env = "prod"
  env_vars = {
    dependencies                 = null
    download_dir                 = ""
    generate                     = {}
    iam_assume_role_duration     = null
    iam_assume_role_session_name = ""
    iam_role                     = ""
    iam_web_identity_token       = ""
    inputs                       = null
    locals = {
      env         = "prod"
      name_prefix = "supabase"
    }
    retry_max_attempts            = null
    retry_sleep_interval_sec      = null
    retryable_errors              = null
    terraform_binary              = ""
    terraform_version_constraint  = ""
    terragrunt_version_constraint = ""
  }
  name_prefix = "supabase"
  region      = "us-east-1"
}
terraform {
  source = "../../../..//modules/networking"
  extra_arguments "optimization" {
    commands  = ["init", "apply", "plan", "destroy"]
    arguments = ["-no-color"]
  }
  before_hook "ensure_init" {
    commands = ["apply", "plan", "destroy"]
    execute  = ["terraform", "init", "-upgrade=false"]
  }
}
remote_state {
  backend = "s3"
  config = {
    acl            = "private"
    bucket         = "supabase-infra-backend-prod-us-east-1"
    dynamodb_table = "tf-locks-prod-us-east-1"
    encrypt        = true
    key            = "prod/live/prod/us-east-1/networking/terraform.tfstate"
    region         = "us-east-1"
  }
}
generate "provider" {
  path        = "provider.tf"
  if_exists   = "overwrite_terragrunt"
  if_disabled = "skip"
  contents    = "provider \"aws\" {\n  region = \"us-east-1\"\n  allowed_account_ids = [\"688567272993\"]\n\n  # Add security best practices\n  default_tags {\n    tags = {\n      CreatedBy   = \"terragrunt\"\n      ManagedBy   = \"terrasible\"\n    }\n  }\n}\n"
}
inputs = {
  azs              = ["us-east-1a", "us-east-1b"]
  database_subnets = ["10.0.50.0/24", "10.0.51.0/24"]
  env              = "prod"
  name_prefix      = "supabase"
  private_subnets  = ["10.0.0.0/22", "10.0.4.0/22"]
  public_subnets   = ["10.0.100.0/24", "10.0.101.0/24"]
  region           = "us-east-1"
  tags = {
    component = "networking"
    env       = "prod"
  }
  vpc_cidr = "10.0.0.0/16"
  zones    = ["us-east-1a", "us-east-1b"]
}
