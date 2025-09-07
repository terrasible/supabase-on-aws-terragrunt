# Generate random suffix for unique resource naming
resource "random_id" "eks_suffix" {
  byte_length = 3
}

# trivy:ignore:AVD-AWS-0040: Enabling public access to EKS cluster from internet.This is a temporary configuration since no VPN is available. Consider implementing VPN access in production.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.1"

  name                     = "${var.name_prefix}-${var.env}-${random_id.eks_suffix.hex}"
  kubernetes_version       = "1.33"
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  # API Endpoint Access
  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  # IAM & Security Config
  enable_cluster_creator_admin_permissions = true
  create_kms_key                           = true
  create_iam_role                          = true
  create_node_iam_role                     = true
  create_node_security_group               = true
  create_security_group                    = true
  deletion_protection                      = false

  # KMS & Encryption
  encryption_policy_name = "${var.name_prefix}-${var.env}-${random_id.eks_suffix.hex}-encryption-policy"
  kms_key_description    = "KMS key for EKS encryption"
  kms_key_aliases        = ["${var.name_prefix}-${var.env}-encryption-key"]

  # IAM Role
  iam_role_description = "IAM role for EKS cluster"
  iam_role_name        = "${var.name_prefix}-${var.env}-${random_id.eks_suffix.hex}-iam-role"
  region               = var.region

  # Allow API access from current IP and NLB traffic
  security_group_additional_rules = {
    ingress_https_api = {
      description = "Allow HTTPS API access from your IP only"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
    # Allow NLB health checks and traffic from within VPC
    ingress_nlb_traffic = {
      description = "Allow NLB traffic from VPC for global access"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  # Control Plane Logging
  enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = 30

  # Essential Add-ons
  addons = {
    coredns                = { most_recent = true }
    eks-pod-identity-agent = { most_recent = true, before_compute = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true, before_compute = true }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.ebs_csi_irsa_role.arn
    } #For deploying Prometheus as statefulset
  }

  # Managed Node Group for Supabase workloads
  eks_managed_node_groups = {
    supabase = {
      name           = "${var.name_prefix}-${var.env}-${random_id.eks_suffix.hex}"
      instance_types = ["t4g.medium"]
      capacity_type  = "ON_DEMAND"
      min_size       = 2
      max_size       = 10
      desired_size   = 3
      ami_type       = "AL2023_ARM_64_STANDARD"

      # Node group policies (EBS CSI driver uses IRSA instead)
      iam_role_additional_policies = {}

      labels = {
        workload = "supabase"
      }
      tags = var.tags
    }
  }

  tags = var.tags
}

# IAM role for EBS CSI driver
resource "aws_iam_role" "ebs_csi_irsa_role" {
  name = "${var.name_prefix}-${var.env}-ebs-csi-driver"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_irsa_role.name
}
