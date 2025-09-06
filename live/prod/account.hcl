# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# root.hcl configuration.
locals {
  account_name       = "prod"
  account_id         = "688567272993"
  remote_bucket_name = "supabase-infra-backend"
}
