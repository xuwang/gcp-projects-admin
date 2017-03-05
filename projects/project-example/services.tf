# The services/APIs that are enabled for this project. 
# For a list of available services, run "gcloud service-management list"

resource "google_project_services" "project_services" {
  depends_on = ["google_project.project"]
  
  project = "${var.project_id}"
  services = [
	"bigquery-json.googleapis.com",
	"cloudbilling.googleapis.com",
	"clouddebugger.googleapis.com",
	"cloudresourcemanager.googleapis.com",
	"compute-component.googleapis.com",
	"container.googleapis.com",
	"dataflow.googleapis.com",
	"dataproc.googleapis.com",
	"dataproc-control.googleapis.com",
	"deploymentmanager.googleapis.com",
	"dns.googleapis.com",
	"iam.googleapis.com",
	"logging.googleapis.com",
	"monitoring.googleapis.com",
	"plus.googleapis.com",
	"prediction.googleapis.com",
	"pubsub.googleapis.com",
	"resourceviews.googleapis.com",
	"servicemanagement.googleapis.com",
	"sql-component.googleapis.com",
	"storage-api.googleapis.com",
	"storage-component.googleapis.com"
  	]
}
