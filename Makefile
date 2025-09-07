# Configuration variables
TF_PATH ?= /opt/homebrew/bin/terraform
WORKING_DIR ?= live/prod/us-east-1
PARALLELISM ?= 4

# Common terragrunt flags
TG_FLAGS = --backend-bootstrap \
		   --working-dir $(WORKING_DIR) \
		   --provider-cache \
		   --parallelism $(PARALLELISM) \
		   --non-interactive \
		   --tf-path $(TF_PATH) \
		   --queue-exclude-dir live/prod/us-east-1/supabase

.PHONY: cost clean init validate plan apply destroy destroy-plan fmt lint help

cost:
	@command -v infracost >/dev/null || (echo "Infracost not installed" && exit 1)
	infracost breakdown --path . --format json --out-file cost-report/infracost.json
	infracost output --format html --path cost-report/infracost.json --out-file cost-report/infracost.html

clean:
	find . -type d \( -name ".terragrunt-cache" -o -name ".terraform" \) -exec rm -rf {} + 2>/dev/null || true
	find . -type f \( -name ".terraform.lock.hcl" \) -delete 2>/dev/null || true

init:
	terragrunt init -all $(TG_FLAGS)
	git submodule update --init --recursive

fmt:
	terraform fmt -recursive .
	terragrunt hcl fmt --check
	terragrunt hcl fmt --diff

validate:
	terragrunt validate -all $(TG_FLAGS)

lint:
	(cd modules/eks && tflint --config=../../.tflint.hcl .)
	(cd modules/networking && tflint --config=../../.tflint.hcl .)
	(cd modules/rds && tflint --config=../../.tflint.hcl .)

plan:
	terragrunt plan -all $(TG_FLAGS)

apply:
	terragrunt apply -all $(TG_FLAGS)

destroy:
	terragrunt destroy -all $(TG_FLAGS)

destroy-plan:
	terragrunt destroy -plan -all $(TG_FLAGS)

plan-supabase:
	terragrunt plan -all --backend-bootstrap --working-dir live/prod/us-east-1/supabase --provider-cache --parallelism $(PARALLELISM) \
		   --non-interactive \
		   --tf-path $(TF_PATH)
apply-supabase:
	terragrunt apply -all --backend-bootstrap --working-dir live/prod/us-east-1/supabase --provider-cache --parallelism $(PARALLELISM) \
		   --non-interactive \
		   --tf-path $(TF_PATH)

help:
	@echo "Available targets:"
	@echo "  cost         - Generate infrastructure cost report"
	@echo "  clean        - Remove terragrunt and terraform cache files"
	@echo "  fmt          - Format terraform and terragrunt files"
	@echo "  lint         - Run TFLint on terraform files"
	@echo "  init         - Initialize terragrunt modules"
	@echo "  validate     - Validate terraform configurations"
	@echo "  plan         - Generate terraform execution plan"
	@echo "  apply        - Apply terraform changes"
	@echo "  destroy      - Destroy terraform resources"
	@echo "  destroy-plan - Generate terraform destroy plan"
	@echo ""
	@echo "Configuration variables (can be overridden):"
	@echo "  TF_PATH      - Path to terraform binary (default: /opt/homebrew/bin/terraform)"
	@echo "  WORKING_DIR  - Terragrunt working directory (default: live/prod/us-east-1)"
	@echo "  PARALLELISM  - Number of parallel operations (default: 4)"
	@echo ""
	@echo "Examples:"
	@echo "  make plan TF_PATH=/usr/bin/terraform"
	@echo "  make validate WORKING_DIR=live/non-prod/us-east-1"
	@echo "  make apply PARALLELISM=2"
