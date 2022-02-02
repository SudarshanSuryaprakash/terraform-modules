module "infra" {
  source = "../../"

  web_image_tag = var.app_version
  api_image_tag = var.app_version

  environment                  = "dev"
  project_id                   = "bdgcmrifernsp01-8319"
  artifact_registry_repository = "us-east4-docker.pkg.dev/bdgcmrifernsp01-8319/bdgcmrifernar01"
  domain                       = "fern-dev.elancosolutions.com"

  api_env_vars = {
    "APP_NAME"                            = "solops-appexcellence-template-web-fern"
    "APP_VERSION"                         = "0.0.0"
    "PROJECT_ID"                          = "bdgcmrifernsp01-8319"
    "USE_APPLICATION_DEFAULT_CREDENTIALS" = true
    "SWAGGER_ENABLED"                     = false
    "SWAGGER_ROUTE"                       = "/swagger"
    "SWAGGER_OAUTH_REDIRECT_ROUTE"        = "https://fern-template-dev.elancosolutions.com/swagger/oauth2-redirect.html"
    "KEY_FILENAME"                        = "test"
    "AUTH_ENABLED"                        = false
    "AUTH_AZURE_TENANTID"                 = "8e41bacc-baba-48d6-9fcb-708bd1208e38"
    "AUTH_AZURE_CLIENTID"                 = "3111b64e-ccd2-459f-8ba1-6b157e1bbf2a"
    "AUTH_API_SCOPE"                      = "api://3111b64e-ccd2-459f-8ba1-6b157e1bbf2a/access_as_user"
  }

  web_env_vars = {
    "REACT_APP_APP_NAME"              = "solops-appexcellence-template-web-fern"
    "REACT_APP_APP_VERSION"           = "0.0.0"
    "REACT_APP_API_URL"               = "https://fern-template-dev.elancosolutions.com/api-service"
    "REACT_APP_ENABLE_AUTHENTICATION" = true
    "NEXTAUTH_URL"                    = "https://fern-template-dev.elancosolutions.com"
    "NEXTAUTH_SECRET"                 = "JV11k1QkhSiXZiJXAGKAj7w974Us5OaRTQeZ38hXA2o="
    "AZURE_AD_CLIENT_ID"              = "3111b64e-ccd2-459f-8ba1-6b157e1bbf2a"
    "AZURE_AD_TENANT_ID"              = "8e41bacc-baba-48d6-9fcb-708bd1208e38"
    "AZURE_AD_CLIENT_SECRET"          = ""
    "AZURE_AD_API_SCOPE"              = "api://3111b64e-ccd2-459f-8ba1-6b157e1bbf2a/access_as_user"
  }

  backend_services = {
    "web" = [
      "web-us-east-service"
    ],
    "api" = [
      "api-us-east-service"
    ]
  }

  url_map_default = "web"

  url_map = {
    "api" = {
      "paths" = [
        "/api-service",
        "/api-service/*",
        "/swagger",
        "/swagger/*"
      ],
      "backend" = "api"
    }
  }
}
