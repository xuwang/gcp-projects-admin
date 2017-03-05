# Create GCP Projecct
resource "google_project" "project" {
    project_id = "${var.project_id}"
    name = "${var.project_id}"
    org_id = "${var.org_id}"
    billing_account = "${var.billing_id}"
}

# Set Project IAM Policy
resource "google_project_iam_policy" "iam_bindings" {
    project = "${var.project_id}"
    policy_data = "${data.google_iam_policy.iam_bindings.policy_data}"
}