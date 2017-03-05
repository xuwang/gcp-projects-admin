# iam bindings
data "google_iam_policy" "iam_bindings" {
  depends_on = ["google_project.project"]
  
  binding {
    role = "roles/owner"
    members = [
      "user:admin@example.com"
    ]
  }
  binding {
    role = "roles/editor"
    members = [
      "serviceAccount:${google_service_account.provision.email}",
      "user:developer@example.com"
    ]
  }
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${google_service_account.gcr_user.email}"
    ]
  }
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "serviceAccount:${google_service_account.gcr_pull.email}"
    ]
  }
}