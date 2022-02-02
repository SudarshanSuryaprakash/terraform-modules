variable "environment" {
  type        = string
  description = "One of (dev, qa, prod)"
}

variable "project_id" {
  type        = string
  description = "Project ID to land the pattern deployment"
}

variable "artifact_registry_repository" {
  type = string
}

variable "url_map_default" {
  type = string
}

variable "url_map" {
  type = map(any)
}

variable "domain" {
  type = string
}

variable "web_image_tag" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "api_env_vars" {
  type = map(any)
}

variable "web_env_vars" {
  type = map(any)
}

variable "backend_services" {
  type = map(any)
}

variable "enable_memorystore" {
  type        = bool
  description = "Enables memorystore if 'true' (default 'false')"
  default     = false
}

