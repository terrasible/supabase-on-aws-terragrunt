###################################
# Cert-Manager Deployment
###################################

# Create namespace for cert-manager
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "cert-manager.io/disable-validation" = "true"
    }
  }
}

# Deploy cert-manager using Helm with values file
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = "v1.18.2"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  # Timeout and wait configurations
  timeout       = 600 # 10 minutes
  wait          = true
  wait_for_jobs = true

  # Enable CRDs installation
  set {
    name  = "crds.enabled"
    value = "true"
  }

  values = [
    file("${path.module}/values/cert-manager-values.yaml")
  ]

  depends_on = [kubernetes_namespace.cert_manager]
}
