/* ----------------------- Create the Service Account ----------------------- */

resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name}-sa"
}

/* -------------------- Add Firestore Access if Required -------------------- */

resource "google_project_iam_member" "policy_binding" {
  count   = var.needs_firestore_access ? 1 : 0
  project = var.project
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
