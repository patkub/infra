# Cloudflare Domain Overview Account ID
variable "cf_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

# Cloudflare Domain Overview API Zone ID
variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

# Cloudflare Access Team
variable "cf_access_team" {
  description = "Cloudflare Access Team"
  type        = string
  sensitive   = false
}

# Auth0 Client ID for Cloudflare Access OIDC Client
variable "auth0_client_cloudflare_access_id" {
  description = "Cloudflare Access Auth0 Client ID"
  type        = string
  sensitive   = false
}
