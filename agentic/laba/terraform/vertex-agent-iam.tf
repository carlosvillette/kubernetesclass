variable "project_id" {}
variable "region" {
  default = "us-central1"
}

resource "google_project_service" "vertex_ai" {
  project = var.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_project_service" "logging" {
  project = var.project_id
  service = "logging.googleapis.com"
}

resource "google_service_account" "vertex_agent" {
  account_id   = "vertex-gke-agent"
  display_name = "Vertex GKE Agent Service Account"
}

resource "google_project_iam_member" "vertex_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertex_agent.email}"
}

resource "google_project_iam_member" "logging_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.vertex_agent.email}"
}
