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