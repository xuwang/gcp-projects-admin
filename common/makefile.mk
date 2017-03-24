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
	cd ../..; make auth

init: ## Initialize terraform if the remote state is not setup.
	@if [ -a build/.terraform/terraform.tfstate ] ; \
	then \
		echo "Already initialized" ; \
	else \
		make remote ; \
		make update ; \
	fi

update: update-secrets ## Update common files and do terraform init 
	rm -rf build
	mkdir -p build
	cp *.tf build
	cp ../../common/tf/*.tf build
	cat ../../common/tf/init.tf | envsubst > build/init.tf 
	cat ../../common/tf/terraform.tfvars | envsubst > build/terraform.tfvars
	${TF_CMD} init

update-secrets: ## Update secrets files
	rm -rf secrets
	mkdir -p secrets
	cp ${GOOGLE_APPLICATION_CREDENTIALS} secrets/provision.json


remote: auth ## setup and config Terraform remote state
	@echo set remote state to gs://${TF_REMOTE_STATE_BUCKET}/${TF_REMOTE_STATE_PATH}

	@if ! gsutil ls -p ${GCP_ADMIN_PROJECT_ID} gs://${TF_REMOTE_STATE_BUCKET}; \
	then \
		echo creating bucket for remote state ... ; \
		gsutil mb -p ${GCP_ADMIN_PROJECT_ID} gs://${TF_REMOTE_STATE_BUCKET}; \
		sleep 10; \
	fi
	
plan: init ## plan the gcp project provisioning
	${TF_CMD} plan

apply: init ## provisioning the gcp project
	${TF_CMD} apply

show: init ## show gcp project resources
	${TF_CMD}  show

destroy: init ## destroy the gcp project, DON'T DO IT
	${TF_CMD} destroy ${DESTROY_OPTS}

refresh: init ## refresh state from the gcp project
	${TF_CMD} refresh

clean: ## delete local terraform state
	rm -rf build

list-sc: ## list gcloud service accounts
	@gcloud --project=${GCP_PROJECT_ID} iam service-accounts list

list-provision-key: ## list provision service account keys
	@gcloud iam service-accounts keys list \
		--iam-account=provision@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
		--project=${GCP_PROJECT_ID} 

new-provision-key: ## create a private key for the provision service account, save in secrets/${GCP_PROJECT_ID}/provision.json
	@mkdir -p ${SEC_PATH}/${GCP_PROJECT_ID}
	@if [ -a ${SEC_PATH}/${GCP_PROJECT_ID}/provision.json ] ; \
	then \
		echo "ERROR: ${SEC_PATH}/${GCP_PROJECT_ID}/provision.json exist, revoke before create a new one" ; \
	else \
		gcloud iam service-accounts keys create ${SEC_PATH}/${GCP_PROJECT_ID}/provision.json \
			--iam-account=provision@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
			--project=${GCP_PROJECT_ID}; \
	fi

new-gcr-user-key: ## create a private key for the gcr service account, save in secrets/${GCP_PROJECT_ID}/gcr-user.json
	@mkdir -p ${SEC_PATH}/${GCP_PROJECT_ID}
	@if [ -a ${SEC_PATH}/${GCP_PROJECT_ID}/gcr-use.json ] ; \
	then \
		echo "ERROR: ${SEC_PATH}/${GCP_PROJECT_ID}/provision.json exist, revoke before create a new one" ; \
	else \
		gcloud iam service-accounts keys create ${SEC_PATH}/${GCP_PROJECT_ID}/gcr-use.json \
			--iam-account=provision@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
			--project=${GCP_PROJECT_ID}; \
	fi

new-gcr-pull-key: ## create a private key for the gcr-pull service account, save in secrets/${GCP_PROJECT_ID}/gcr-pull.json
	@mkdir -p ${SEC_PATH}/${GCP_PROJECT_ID}
	@if [ -a ${SEC_PATH}/${GCP_PROJECT_ID}/gcr-pull.json ] ; \
	then \
		echo "ERROR: ${SEC_PATH}/${GCP_PROJECT_ID}/provision.json exist, revoke before create a new one" ; \
	else \
		gcloud iam service-accounts keys create ${SEC_PATH}/${GCP_PROJECT_ID}/gcr-pull.json \
			--iam-account=provision@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
			--project=${GCP_PROJECT_ID}; \
	fi

.PHONY: auth remote plan apply show destroy clean remote_push remote_pull update update-secrets
.PHONY: help list-sc list-provision-key new-provision-key new-gcr-key new-gcr-pull-key
