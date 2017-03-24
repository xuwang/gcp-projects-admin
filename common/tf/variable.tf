# Terraform vars, default values are defined in common/env.sh,Makefile

# Vars for remote state bucket and provisoning credentials
variable "google_admin_project_id" {}
variable "remote_state_bucket" {}
variable "google_credentials_file" {}
# Google project org id
variable "org_id" {}
# Google project id, must be unique
variable "project_id" {}
# Google org billing account id
variable "billing_id" {}
