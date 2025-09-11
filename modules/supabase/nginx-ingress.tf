###################################
# NGINX Ingress Controller with NLB
###################################
resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-${var.env}-supabase-sg"
  description = "Security group for Supabase services"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from public internet for ALB access
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana from Internet"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.env}-supabase-sg"
  })
}

# Create namespace for ingress-nginx
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
    labels = {
      "app.kubernetes.io/name"     = "ingress-nginx"
      "app.kubernetes.io/instance" = "ingress-nginx"
    }
  }
}

# Deploy NGINX Ingress Controller using Helm with values file
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.13.2"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  values = [
    templatefile("${path.module}/values/nginx-values.yaml", {
      supabase_security_group_id = aws_security_group.nlb.id
    })
  ]

  depends_on = [
    kubernetes_namespace.ingress_nginx,
    helm_release.cert_manager
  ]

  timeout = 600
}

# Data source to get the load balancer hostname
data "kubernetes_service" "nginx_ingress_lb" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  }
  depends_on = [helm_release.nginx_ingress]
}
