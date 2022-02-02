resource "google_project_service" "memorystore" {
  project                    = var.project_id
  service                    = "redis.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_redis_instance" "default" {
  depends_on = [ google_project_service.memorystore ]
  project        = var.project_id
  name           = var.name
  tier           = var.tier
  memory_size_gb = var.memory_size_gb
  connect_mode   = var.connect_mode

  region                  = var.region
  location_id             = var.location_id
  alternative_location_id = var.alternative_location_id

  authorized_network = var.authorized_network

  redis_version     = var.redis_version
  redis_configs     = var.redis_configs
  display_name      = var.display_name
  reserved_ip_range = var.reserved_ip_range

  labels = var.labels

  auth_enabled = var.auth_enabled

  transit_encryption_mode = var.transit_encryption_mode
}