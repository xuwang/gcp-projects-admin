# Terraform vars, default values are defined in common/env.sh,Makefile

# Vars for remote state bucket and provisoning credentials
variable "google_admin_project_id" {}
variable "remote_state_bucket" {}
variable "google_credentials_file" {}
# Google project org id
variable "org_id" {}
# Google project id, must be unique
variable "project_id" {}
# Google project name
variable "project_name" {}
# Google org billing account id
variable "billing_id" {}

# Configure the Google Cloud provider
provider "google" {
    credentials = "${file("${var.google_credentials_file}")}"
    project = "${var.google_admin_project_id}"
    region = "us-west1"
}

provider "google" {
    alias = "project"
    credentials = "${file("${var.google_credentials_file}")}"
    project = "${var.project_id}"
    region = "us-west1"
}