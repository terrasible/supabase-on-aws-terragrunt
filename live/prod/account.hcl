# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# root.hcl configuration.
locals {
  account_name       = "prod"
  account_id         = "XXXXXXXXX"
  remote_bucket_name = "supabase-infra-backend"
}
