output "id" {
  description = "The memorystore instance ID."
  value       = google_redis_instance.default.id
}

output "host" {
  description = "The IP address of the instance."
  value       = google_redis_instance.default.host
}

output "port" {
  description = "The port number of the exposed Redis endpoint."
  value       = google_redis_instance.default.port
}

output "region" {
  description = "The region the instance lives in."
  value       = google_redis_instance.default.region
}

output "current_location_id" {
  description = "The current zone where the Redis endpoint is placed."
  value       = google_redis_instance.default.current_location_id
}