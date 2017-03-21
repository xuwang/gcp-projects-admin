include ../../common/env.sh
include env.sh

# Get the current dir as the project id:
export GCP_PROJECT_ID := $(notdir $(shell pwd))
export GCP_PROJECT_NAME := ${GCP_PROJECT_ID}
export TF_VAR_org_id := $(shell cat ${ORG_ID_FILE})
export TF_VAR_billing_id := $(shell cat ${BILLING_ID_FILE})
export TF_VAR_project_id := ${GCP_PROJECT_ID}

help: ## this info
	@# adapted from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo '_________________'
	@echo '| Make targets: |'
	@echo '-----------------'
	@cat ../../common/Makefile | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

auth: ## activate gclound service account
	@gcloud auth activate-service-account --key-file ${GOOGLE_APPLICATION_CREDENTIALS}

init: ## Initialize terraform if the remote state is not setup.
	@if [ -a .terraform/terraform.tfstate ] && [ -a init.tf ]; then echo "Already initialized"; else make remote; fi

remote: auth ## setup and config Terraform remote state
	@echo set remote state to gs://${TF_REMOTE_STATE_BUCKET}/${TF_REMOTE_STATE_PATH}

	@if ! gsutil ls -p ${GCP_ADMIN_PROJECT_ID} gs://${TF_REMOTE_STATE_BUCKET}/${TF_REMOTE_STATE_PATH}; \
	then \
		echo creating bucket for remote state ... ; \
		gsutil mb -p ${GCP_ADMIN_PROJECT_ID} gs://${TF_REMOTE_STATE_BUCKET}/${TF_REMOTE_STATE_PATH}; \
		sleep 30; \
	fi
	cat ../../common/init.conf | envsubst > init.tf
	terraform init

plan: init ## plan the gcp project provisioning
	terraform plan

apply: init ## provisioning the gcp project
	terraform apply

show: init ## show gcp project resources
	terraform show

destroy: init ## destroy the gcp project, DON'T DO IT
	terraform destroy ${DESTROY_OPTS}

refresh: init ## refresh state from the gcp project
	terraform refresh

clean: ## delete local terraform state
	rm -rf .terraform

remote-push: init ## push state to remote
	terraform remote push

remote-pull: init ## pull state from remote
	terraform remote pull

.PHONY: auth remote plan apply show destroy clean remote_push remote_pull
.PHONY: help
