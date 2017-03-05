# Default service account for this project

# For provisioning
resource "google_service_account" "provision" {
	# make sure the service account is created in newly created google.project
	depends_on = ["google_project.project", "google_project_services.project_services"]
	provider = "google.project"

    account_id = "provision"
    display_name = "provision"
}

# Create service account for private docker registry
resource "google_service_account" "gcr_user" {
	# make sure the service account is created in newly created google.project
	depends_on = ["google_project.project", "google_project_services.project_services"]
	provider = "google.project"

    account_id = "gcr-user"
    display_name = "gcr-user"
}

# Create service account for read only private docker registry
resource "google_service_account" "gcr_pull" {
	# make sure the service account is created in newly created google.project
	depends_on = ["google_project.project", "google_project_services.project_services"]
	provider = "google.project"

    account_id = "gcr-pull"
    display_name = "gcr-pull"
}