# GCLOUD Configuration for remote state and project

# gcp service account key abslute file path, do NOT quote
export GOOGLE_APPLICATION_CREDENTIALS=
# tremote state bucket project id, do NOT quote
export GCP_ADMIN_PROJECT_ID=
# gcp organization id, do NOT quote
export TF_VAR_org_id=
# gcp organization billing id, do NOT quote
export TF_VAR_billing_id=

export GCP_CONFIGURATION=gcp-projects-admin
export CLOUDSDK_CONTAINER_USE_CLIENT_CERTIFICATE=True

# Terraform state files
export TF_VERSION=~>0.9
export TF_IMAGE=hashicorp/terraform:0.9.1
export TF_CMD=docker run -v="${PWD}/build:/build" -v="${PWD}/secrets:/secrets" -w="/build" ${TF_IMAGE}
export TF_REMOTE_STATE_BUCKET=${GCP_ADMIN_PROJECT_ID}-terraform
export TF_REMOTE_STATE_PATH=projects/${GCP_PROJECT_ID}.tfstate
export DESTROY_OPTS=

# Terraform vars
export TF_VAR_secrets_path=/secrets
export TF_VAR_google_credentials_file=/secrets/provision.json
export TF_VAR_google_admin_project_id=${GCP_ADMIN_PROJECT_ID}
export TF_VAR_remote_state_bucket=${REMOTE_STATE_BUCKET}