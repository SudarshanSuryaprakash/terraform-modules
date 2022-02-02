variable "name" {
  type = string
}

variable "container_url" {
  type = string
}

variable "needs_firestore_access" {
  type = bool
}
variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "container_port" {
  type = string
}

variable "env_vars" {
  type = map(any)
}
