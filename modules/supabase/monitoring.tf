# Monitoring Stack - Prometheus, Grafana, and AlertManager
# This must be deployed before Supabase components

# Generate random password for Grafana admin
resource "random_password" "grafana_admin" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Create monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }
}

# Prometheus CRDs and Operator
resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "77.5.0"

  values = [
    templatefile("${path.module}/values/monitoring-values.yaml", {
      grafana_admin_password = random_password.grafana_admin.result,
      domain_name            = var.domain_name
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}
