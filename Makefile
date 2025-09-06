cost:
	@command -v infracost >/dev/null || (echo "Infracost not installed" && exit 1)
	infracost breakdown --path . --format json --out-file cost-report/infracost.json
	infracost output --format html --path cost-report/infracost.json --out-file cost-report/infracost.html


clean:
	find . -type d \( -name ".terragrunt-cache" -o -name ".terraform" \) -exec rm -rf {} + 2>/dev/null || true
	find . -type f \( -name ".terraform.lock.hcl" \) -delete 2>/dev/null || true

init:
	terragrunt init -all \
		--backend-bootstrap \
		--working-dir live/prod/us-east-1 \
		--provider-cache \
		--parallelism 4 \
		--non-interactive \
		--tf-path /opt/homebrew/bin/terraform

validate:
	terragrunt validate -all \
		--backend-bootstrap \
		--working-dir live/prod/us-east-1 \
		--provider-cache \
		--parallelism 4 \
		--non-interactive \
		--tf-path /opt/homebrew/bin/terraform

plan:
	terragrunt plan -all \
		--backend-bootstrap \
		--working-dir live/prod/us-east-1 \
		--provider-cache \
		--parallelism 4 \
		--non-interactive \
		--tf-path /opt/homebrew/bin/terraform

apply:
	terragrunt apply -all \
		--backend-bootstrap \
		--working-dir live/prod/us-east-1 \
		--provider-cache \
		--parallelism 4 \
		--non-interactive \
		--tf-path /opt/homebrew/bin/terraform

destroy:
	export TG_NON_INTERACTIVE=true
	terragrunt run-all destroy --non-interactive
