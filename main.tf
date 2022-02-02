locals {
  required_apis = [
    "iam.googleapis.com",
    "run.googleapis.com"
  ]
}

/* 
  Enable required APIs
*/

resource "google_project_service" "project_apis" {
  for_each = toset(local.required_apis)

  project = var.project_id
  service = each.key
}


/* -------------------------------------------------------------------------- */
/*                        Create the Cloud Run Services                       */
/* -------------------------------------------------------------------------- */

module "web-us-east-service" {
  source = "./modules/cloud_run_service"

  project_id             = var.project_id
  name                   = "web-us-east"
  region                 = "us-east4"
  needs_firestore_access = false
  container_url          = "${var.artifact_registry_repository}/web:${var.web_image_tag}"
  container_port         = "8080"
  env_vars               = var.web_env_vars
  depends_on = [
    google_project_service.project_apis,
  ]
}

module "api-us-east-service" {
  source = "./modules/cloud_run_service"

  project_id             = var.project_id
  name                   = "api-us-east"
  region                 = "us-east4"
  needs_firestore_access = true
  container_url          = "${var.artifact_registry_repository}/api:${var.api_image_tag}"
  container_port         = "8080"
  env_vars               = var.api_env_vars
}

/* -------------------------------------------------------------------------- */
/*                          Create the Load Balancer                          */
/* -------------------------------------------------------------------------- */

module "global_load_balancer" {
  source = "./modules/load_balancer"

  project_id = var.project_id
  domain     = var.domain
  cloud_run_services = {
    "web-us-east-service" = module.web-us-east-service,
    "api-us-east-service" = module.api-us-east-service
  }
  url_map_default  = var.url_map_default
  url_map          = var.url_map
  backend_services = var.backend_services
}

/* ------------------- DNS Entry in shared (temp) project ------------------- */
# TODO: Figure out a different approach that doesn't require privileges over the DNS zone

resource "google_dns_record_set" "dns_record" {
  project      = "temp-dns-shared-project-001"
  name         = "${var.domain}."
  type         = "A"
  ttl          = 300
  managed_zone = "elancosolutions-com"
  rrdatas = [
    module.global_load_balancer.address
  ]
}

/* -------------------------------------------------------------------------- */
/*                       Create the Firestore instances                       */
/* -------------------------------------------------------------------------- */

module "firestore" {
  source = "./modules/firestore"

  project_id = var.project_id
}

module "memorystore" {
  count          = var.enable_memorystore ? 1 : 0
  source         = "./modules/memorystore"
  name           = "memorystore_example"
  project_id     = var.project_id
  region         = "us-east4"
  memory_size_gb = "1"
}
