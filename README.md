# Supabase on AWS with Terragrunt

Production-ready Supabase deployment on AWS EKS using Terraform and Terragrunt. Includes managed PostgreSQL, monitoring with Prometheus & Grafana, and secure secrets management.

![Supabase Architecture](assets/supabase-architecture.png)

## 🏗️ Architecture

- **EKS Cluster**: Managed Kubernetes for Supabase services
- **RDS PostgreSQL**: Managed database with HA
- **VPC & Networking**: Secure network with public/private subnets
- **S3 Storage**: Object storage for Supabase
- **Monitoring**: Prometheus, Grafana, cert-manager
- **Ingress**: NGINX with SSL/TLS termination

## 📋 Prerequisites

```bash
# Install required tools (macOS)
brew install terraform terragrunt awscli kubectl helm

# Optional development tools
brew install tflint infracost
pip install pre-commit && pre-commit install

# Configure AWS
aws configure
```


## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone <repository-url>
cd supabase-on-aws-terragrunt
git submodule update --init --recursive

# 2. Configure environment
# Edit live/prod/account.hcl with your AWS account ID and bucket name
# Terragrunt auto-creates state bucket and DynamoDB table

# 3. Deploy infrastructure
make plan    # Review changes
make apply   # Deploy everything

# Or deploy Supabase only
make plan-supabase && make apply-supabase
```

## 🛠️ Available Commands

```bash
# Infrastructure
make init validate plan apply destroy
make plan-supabase apply-supabase  # Supabase only

# Maintenance
make fmt lint clean cost

# Configuration overrides
make plan TF_PATH=/usr/local/bin/terraform
make apply PARALLELISM=2
```

## 📁 Project Structure

```
live/prod/us-east-1/     # Environment configs
├── eks/                 # EKS cluster
├── networking/          # VPC setup
├── rds/                 # PostgreSQL
├── s3/                  # Storage
└── supabase/           # Supabase app

modules/                 # Terraform modules
charts/                  # Helm charts
scripts/smoke-test.sh    # Endpoint testing
```

## 🔧 Configuration

Edit configuration files in `live/prod/us-east-1/*/terragrunt.hcl` for:
- Domain settings (supabase/)
- Database config (rds/)
- Cluster settings (eks/)

## 🧪 Testing & Monitoring

```bash
./scripts/smoke-test.sh                    # Test endpoints
make cost && open cost-report/infracost.html  # Cost analysis
```

## 🚨 Troubleshooting

```bash
# State lock errors
terragrunt force-unlock <lock-id>

# Complete cleanup
make destroy-plan && make destroy && make clean
```

## 🔒 Security

- AWS Secrets Manager for RDS secrets
- TLS/SSL termination at ingress
- Network security groups
- Pre-commit hooks prevent credential leaks
