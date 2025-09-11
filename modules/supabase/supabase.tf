###################################
# Supabase Helm Chart Deployment
###################################

# Supabase namespace
resource "kubernetes_namespace" "supabase" {
  metadata {
    name = "supabase"
    labels = {
      name                         = "supabase"
      "app.kubernetes.io/name"     = "supabase"
      "app.kubernetes.io/instance" = "supabase"
    }
  }
}

# Supabase Helm Release
resource "helm_release" "supabase" {
  name      = "supabase"
  chart     = "charts/upstream-supabase/charts/supabase"
  namespace = kubernetes_namespace.supabase.metadata[0].name

  # Use values file for configuration
  values = [
    templatefile("${path.module}/values/supabase-values.yaml", {
      domain_name      = var.domain_name
      db_host          = var.db_host
      db_port          = var.db_port
      s3_bucket_name   = var.s3_bucket_name
      s3_endpoint      = "https://s3.${var.region}.amazonaws.com"
      region           = var.region
      s3_access_key_id = aws_iam_access_key.supabase_s3_access_key.id
      s3_secret_key    = aws_iam_access_key.supabase_s3_access_key.secret
    })
  ]

  # Ensure dependencies are met
  depends_on = [
    kubernetes_namespace.supabase,
    helm_release.cert_manager,
    helm_release.nginx_ingress
  ]

  # Wait for deployment to be ready
  wait          = true
  wait_for_jobs = true
  timeout       = 600

  # Force update if needed
  force_update    = false
  cleanup_on_fail = true

}
