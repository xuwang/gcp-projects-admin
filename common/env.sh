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
export TF_REMOTE_STATE_BUCKET=${GCP_ADMIN_PROJECT_ID}-terraform
export TF_REMOTE_STATE_PATH=projects/${GCP_PROJECT_ID}.tfstate

# Terraform vars
export DESTROY_OPTS=
export TF_VAR_secrets_path=${SEC_PATH}
export TF_VAR_google_credentials_file=${GOOGLE_APPLICATION_CREDENTIALS}
export TF_VAR_google_admin_project_id=${GCP_ADMIN_PROJECT_ID}
export TF_VAR_remote_state_bucket=${REMOTE_STATE_BUCKET}