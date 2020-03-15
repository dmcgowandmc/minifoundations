SHELL := /bin/bash

.PHONY: prepare_terraform_environment

prepare_terraform_environment:
	@echo "--- Prepare Terraform Environment (This step must run on a Linux based OS) ---"
	@./scripts/prepare-terraform-environment.sh $(PROJECT_CODE) $(REGION)

.PHONY: deploy_environment_init_plan

deploy_environment_init_plan:
	@echo "--- Init and Plan for Environment Deploy (Docker and Compose must be installed) ---"
	@docker-compose run --rm terraform init -backend-config="bucket=$(PROJECT_CODE)-terrastate"
