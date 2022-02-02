/* ------------------------ Enable the Firestore API ------------------------ */

resource "google_project_service" "firestore" {
  project                    = var.project_id
  service                    = "firestore.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "appengine_service" {
  project                    = var.project_id
  service                    = "appengine.googleapis.com"
  disable_dependent_services = true
}

# Use firestore with app engine application
# resource "google_app_engine_application" "app" {
#   depends_on    = [google_project_service.appengine_service]
#   provider      = google-beta
#   location_id   = "us-central"
#   database_type = "CLOUD_FIRESTORE"
#   project       = var.project_id
# }
