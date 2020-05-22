SHELL := /bin/bash

.PHONY: prepare_terraform_environment

prepare_terraform_environment:
	@echo "--- Prepare Terraform Environment (This step must run on a Linux based OS) ---"
	@./scripts/prepare-terraform-environment.sh $(PROJECT_CODE) $(REGION)

.PHONY: terraform_init_plan
terraform_init_plan:
	@echo "--- Init and Plan for Terraform (Docker and Compose must be installed) ---"
	@docker-compose run --rm terraform init -backend-config="bucket=$(PROJECT_CODE)-terrastate" -backend-config="key=foundations/default.tfstate" -backend-config="region=$(REGION)"
	@docker-compose run --rm terraform plan -var project_code=$(PROJECT_CODE) -var "region=$(REGION)"

.PHONY: terraform_apply
terraform_apply:
	@echo "--- Apply for Terraform (Docker and Compose must be installed. The terraform_init_plan must be run first) ---"
	@docker-compose run --rm terraform apply -var project_code=$(PROJECT_CODE) -var "region=$(REGION)" -auto-approve

.PHONY: terraform_destory
terraform_destroy:
	@echo "--- Apply for Terraform (Docker and Compose must be installed. The terraform_init_plan must be run first) ---"
	@docker-compose run --rm terraform destroy -var project_code=$(PROJECT_CODE) -var "region=$(REGION)" -auto-approve