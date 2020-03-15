SHELL := /bin/bash

.PHONY: prepare_terraform_environment

prepare_terraform_environment:
	@echo "--- Prepare Terraform Environment (This step must run on a Linux based OS) ---"
	@./modules/aws/scripts/prepare-terraform-environment.sh $(PROJECT_CODE) $(REGION)