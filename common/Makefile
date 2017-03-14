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

remote: auth ## setup and config Terraform remote state
	@echo set remote state to gcs://${REMOTE_STATE_BUCKET}/${REMOTE_STATE_PATH}

	@if ! gsutil ls -p ${GCP_ADMIN_PROJECT_ID} gs://${REMOTE_STATE_BUCKET}; \
	then \
		echo creating bucket for remote state ... ; \
		gsutil mb -p ${GCP_ADMIN_PROJECT_ID} gs://${REMOTE_STATE_BUCKET}; \
		sleep 30; \
	fi

	@grep -q ${REMOTE_STATE_PATH} ${LOCAL_STATE_PATH} &> /dev/null || \
	( terraform remote config \
    	-backend=gcs \
    	-backend-config="project=${GCP_ADMIN_PROJECT_ID}" \
    	-backend-config="bucket=${REMOTE_STATE_BUCKET}" \
    	-backend-config="path=${REMOTE_STATE_PATH}"; )

plan: remote ## plan the gcp project provisioning
	terraform plan

apply: remote ## provisioning the gcp project
	terraform apply

show: remote ## show gcp project resources
	terraform show

destroy: remote ## destroy the gcp project, DON'T DO IT
	terraform destroy ${DESTROY_OPTS}

refresh: remote ## refresh state from the gcp project
	terraform refresh

clean: ## delete local terraform state
	rm -rf .terraform

remote-push: remote ## push state to remote
	terraform remote push

remote-pull: remote ## pull state from remote
	terraform remote pull

.PHONY: auth remote plan apply show destroy clean remote_push remote_pull
.PHONY: help
