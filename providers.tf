terraform {
  # Required Providers
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1"
    }
  }
}

# Cloudflare Provider Configuration
provider "cloudflare" {
  api_token = var.cf_api_token
}

# Auth0 Provider Configuration
provider "auth0" {
  domain        = var.AUTH0_DOMAIN
  client_id     = var.AUTH0_CLIENT_ID
  client_secret = var.AUTH0_CLIENT_SECRET
}
