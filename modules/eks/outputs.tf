# Cluster outputs
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

# Security outputs
output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}

# OIDC outputs
output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks.oidc_provider_arn
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

# KMS outputs
output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = module.eks.kms_key_arn
}

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = module.eks.kms_key_id
}

# CloudWatch outputs
output "cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = module.eks.cloudwatch_log_group_arn
}

# Cluster addons
output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = module.eks.cluster_addons
}

# Access entries
output "access_entries" {
  description = "Map of access entries created and their attributes"
  value       = module.eks.access_entries
}
