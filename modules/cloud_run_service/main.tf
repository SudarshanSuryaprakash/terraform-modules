/* -------------------------------------------------------------------------- */
/*                         Create the Service Account                         */
/* -------------------------------------------------------------------------- */

module "service_account" {
  source = "../service_account"

  service_name           = var.name
  needs_firestore_access = var.needs_firestore_access
  project                = var.project_id
}

/* -------------------------------------------------------------------------- */
/*                        Create the Cloud Run Service                        */
/* -------------------------------------------------------------------------- */

resource "google_cloud_run_service" "cloud_run_service" {
  name     = var.name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = var.container_url
        ports {
          container_port = var.container_port
        }
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
      service_account_name = module.service_account.service_account_email
    }
  }
  autogenerate_revision_name = true
}

/* ---------------------- Make it publically available ---------------------- */
# FIXME: Does not work. Error:
# A domain restriction organization policy is in place.
# Only principals in allowed domains can be added as principals in the policy.
# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers"
#     ]
#   }
# }

# resource "google_cloud_run_service_iam_policy" "noauth" {
#   project     = var.project_id
#   location    = google_cloud_run_service.cloud_run_service.location
#   service     = google_cloud_run_service.cloud_run_service.name
#   policy_data = data.google_iam_policy.noauth.policy_data
# }
