# GCLOUD Configuration for remote state and project

# gcp service account key abslute file path
export GOOGLE_APPLICATION_CREDENTIALS=
# tremote state bucket project id
export GCP_ADMIN_PROJECT_ID=
# gcp organization id
export TF_VAR_org_id=
# gcp organization billing id
export TF_VAR_billing_id=

export GCP_CONFIGURATION=gcp-projects-admin
export CLOUDSDK_CONTAINER_USE_CLIENT_CERTIFICATE=True

# Terraform state files
export LOCAL_STATE_PATH=.terraform/terraform.tfstate
export REMOTE_STATE_BUCKET=${GCP_ADMIN_PROJECT_ID}-terraform
export REMOTE_STATE_PATH=projects/${GCP_PROJECT_ID}

# Terraform vars
export DESTROY_OPTS=
export TF_VAR_secrets_path=${SEC_PATH}
export TF_VAR_google_credentials_file=${GOOGLE_APPLICATION_CREDENTIALS}
export TF_VAR_google_admin_project_id=${GCP_ADMIN_PROJECT_ID}
export TF_VAR_remote_state_bucket=${REMOTE_STATE_BUCKET}