###################################
# Random Resources for Secrets
###################################
resource "random_password" "analytics_api_key" {
  length  = 32
  special = false
}

resource "random_password" "dashboard_password" {
  length  = 16
  special = true
}

resource "random_password" "smtp_password" {
  length  = 16
  special = true
}

resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

# Generate JWT tokens using Node.js script
resource "null_resource" "jwt_tokens" {
  triggers = {
    jwt_secret = random_password.jwt_secret.result
  }

  provisioner "local-exec" {
    command = "python3 ${path.module}/script/generate-jwt.py '${random_password.jwt_secret.result}' > /tmp/jwt_tokens.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f /tmp/jwt_tokens.txt"
  }
}

data "local_file" "jwt_tokens" {
  filename   = "/tmp/jwt_tokens.txt"
  depends_on = [null_resource.jwt_tokens]
}

locals {
  jwt_output_lines = split("\n", data.local_file.jwt_tokens.content)
  anon_key         = trim(split(":", local.jwt_output_lines[0])[1], " ")
  service_key      = trim(split(":", local.jwt_output_lines[1])[1], " ")
}

# Time resource for epoch
resource "time_static" "epoch" {}

data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = var.db_secretmanager_arn
}

###################################
# Kubernetes Secrets
###################################

resource "kubernetes_secret" "thanos_secret" {
  metadata {
    name      = "supabase-thanos-secret"
    namespace = kubernetes_namespace.supabase.metadata[0].name
  }

  data = {
    jwt_secret         = random_password.jwt_secret.result
    jwt_anon_key       = local.anon_key
    jwt_service_key    = local.service_key
    db_username        = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)["username"]
    db_password        = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)["password"]
    db_database        = var.db_name
    analytics_api_key  = random_password.analytics_api_key.result
    smtp_username      = var.smtp_username
    smtp_password      = random_password.smtp_password.result
    dashboard_username = var.dashboard_username
    dashboard_password = random_password.dashboard_password.result
  }

  type = "Opaque"
}
