/* -------------------------------- Front End ------------------------------- */

resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project_id
  name       = "http-fr"
  port_range = "80"
  ip_address = google_compute_global_address.default.address
  target     = google_compute_target_http_proxy.default.self_link
}

resource "google_compute_global_forwarding_rule" "https" {
  project    = var.project_id
  name       = "https-fr"
  port_range = "443"
  ip_address = google_compute_global_address.default.address
  target     = google_compute_target_https_proxy.default.self_link
}

resource "google_compute_global_address" "default" {
  project    = var.project_id
  name       = "default-ip"
  ip_version = "IPV4"
}

/* ----------------------------- Target Proxies ----------------------------- */

resource "google_compute_target_http_proxy" "default" {
  project = var.project_id
  name    = "http-proxy"
  url_map = google_compute_url_map.https_redirect.self_link
}

resource "google_compute_target_https_proxy" "default" {
  project = var.project_id
  name    = "https-proxy"
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.self_link
  ]
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta
  name     = "managed-certificate"
  project  = var.project_id

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = [var.domain]
  }
}

/* --------------------------- Create the URL Maps -------------------------- */

resource "google_compute_url_map" "default" {
  project = var.project_id
  name    = "default-url-map"

  default_service = google_compute_backend_service.backends[var.url_map_default].id

  host_rule {
    hosts        = [var.domain]
    path_matcher = local.friendly_domain
  }

  path_matcher {
    name            = local.friendly_domain
    default_service = google_compute_backend_service.backends[var.url_map_default].id

    dynamic "path_rule" {
      for_each = var.url_map
      content {
        paths   = path_rule.value.paths
        service = google_compute_backend_service.backends[path_rule.value.backend].id
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "https_redirect" {
  project = var.project_id
  name    = "https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

/* ----------------------- Create the Serverless NEGs ----------------------- */

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider = google-beta
  for_each = var.cloud_run_services

  project               = var.project_id
  name                  = each.key
  network_endpoint_type = "SERVERLESS"
  region                = each.value.region
  cloud_run {
    service = each.value.name
  }
}

/* ----------------------- Create the Backend Services ---------------------- */

resource "google_compute_backend_service" "backends" {
  provider = google-beta
  for_each = var.backend_services

  project = var.project_id
  name    = "${each.key}-backend"

  dynamic "backend" {
    for_each = toset(each.value)
    content {
      group = google_compute_region_network_endpoint_group.serverless_neg[backend.value].id
    }
  }
}
