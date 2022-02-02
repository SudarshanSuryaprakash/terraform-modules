output "region" {
  value = google_cloud_run_service.cloud_run_service.location
}

output "name" {
  value = google_cloud_run_service.cloud_run_service.name
}
