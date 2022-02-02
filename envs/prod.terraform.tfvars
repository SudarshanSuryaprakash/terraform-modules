project_id                    = "web-pattern-prod-env-01"
container_registry_project_id = "web-pattern-prod-env-01"
domain                        = "fern-template.elancosolutions.com"
is_dev                        = false

api_env_vars = {
  "APP_NAME"                            = "Application Name - Prod"
  "APP_VERSION"                         = "0.0.0"
  "PROJECT_ID"                          = "web-pattern-prod-env-01"
  "USE_APPLICATION_DEFAULT_CREDENTIALS" = true
  "SWAGGER_ENABLED"                     = true
  "SWAGGER_ROUTE"                       = "/swagger"
}

web_env_vars = {
  "APP_NAME"            = "Web App"
  "APP_VERSION"         = "0.0.0"
  "NEXT_PUBLIC_API_URL" = "https://fern-template.elancosolutions.com/api"
}

url_map_default = [
  "web-us-east-service"
]

url_map = {
  "api" = [
    "api-us-east-service"
  ]
}
