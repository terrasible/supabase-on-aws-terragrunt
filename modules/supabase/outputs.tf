###################################
# Supabase Service Outputs
###################################
output "supabase_namespace" {
  description = "Kubernetes namespace where Supabase is deployed"
  value       = kubernetes_namespace.supabase.metadata[0].name
}

output "supabase_release_name" {
  description = "Helm release name for Supabase"
  value       = helm_release.supabase.name
}

###################################
# Domain and URL Outputs
###################################
output "supabase_studio_url" {
  description = "URL for Supabase Studio dashboard"
  value       = "http://studio.supabase.${var.domain_name}"
}

output "supabase_api_url" {
  description = "URL for Supabase API endpoints"
  value       = "http://supabase-studio.${var.domain_name}"
}

###################################
# Configuration Outputs
###################################
output "secrets_configuration" {
  description = "Secrets are embedded in values file"
  value       = "hardcoded-in-values"
}

output "ssl_enabled" {
  description = "Whether SSL/TLS is enabled"
  value       = false
}

###################################
# S3 IAM User Outputs
###################################
output "s3_access_key_id" {
  description = "Access key ID for S3 user"
  value       = aws_iam_access_key.supabase_s3_access_key.id
  sensitive   = true
}

output "s3_secret_access_key" {
  description = "Secret access key for S3 user"
  value       = aws_iam_access_key.supabase_s3_access_key.secret
  sensitive   = true
}

output "s3_user_name" {
  description = "Name of the S3 IAM user"
  value       = aws_iam_user.supabase_s3_user.name
}

###################################
# Helm Chart Information
###################################
output "supabase_helm_chart_version" {
  description = "Version of the Supabase Helm chart used"
  value       = helm_release.supabase.version
}

output "supabase_helm_repository_url" {
  description = "URL of the Supabase Helm repository"
  value       = "https://supabase-community.github.io/supabase-kubernetes/charts/"
}

###################################
# Monitoring Outputs
###################################
output "grafana_admin_password" {
  description = "Dynamically generated admin password for Grafana dashboard"
  value       = random_password.grafana_admin.result
  sensitive   = true
}

output "grafana_service_name" {
  description = "Kubernetes service name for Grafana LoadBalancer"
  value       = "prometheus-operator-grafana"
}


output "monitoring_namespace" {
  description = "Namespace where monitoring stack is deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

# NGINX Ingress Controller outputs
output "nginx_ingress_public_ip" {
  description = "Public IP/hostname of the NGINX ingress controller load balancer"
  value       = try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "pending")
  depends_on  = [helm_release.nginx_ingress, data.kubernetes_service.nginx_ingress_lb]
}

output "nginx_ingress_namespace" {
  description = "Namespace where NGINX ingress controller is deployed"
  value       = kubernetes_namespace.ingress_nginx.metadata[0].name
}

output "nginx_load_balancer_hostname" {
  description = "AWS Network Load Balancer hostname for NGINX ingress controller"
  value       = try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "pending")
  depends_on  = [helm_release.nginx_ingress, data.kubernetes_service.nginx_ingress_lb]
}

output "hosts_file_entries" {
  description = "Entries to add to /etc/hosts file for local access"
  value = {
    grafana  = "${try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "pending")} grafana.${var.domain_name}"
    supabase = "${try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "pending")} supabase.${var.domain_name}"
  }
  depends_on = [data.kubernetes_service.nginx_ingress_lb]
}

output "deployment_instructions" {
  description = "Instructions for accessing the services"
  value       = <<-EOT
    1. Get the load balancer hostname: terragrunt output nginx_load_balancer_hostname
    2. Add to /etc/hosts:
       ${try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "<LB_HOSTNAME>")} grafana.${var.domain_name}
       ${try(data.kubernetes_service.nginx_ingress_lb.status[0].load_balancer[0].ingress[0].hostname, "<LB_HOSTNAME>")} supabase.${var.domain_name}
    3. Access services:
       - Grafana: https://grafana.${var.domain_name}
       - Supabase Studio: https://supabase.${var.domain_name}
    4. Default credentials will be auto-generated and stored in Kubernetes secrets
  EOT
  depends_on  = [data.kubernetes_service.nginx_ingress_lb]
}
