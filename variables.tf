
variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "cf_email" {
  description = "Cloudflare Account Email"
  type        = string
  sensitive   = true
}

variable "cf_api_key" {
  description = "Cloudflare API Key"
  type        = string
  sensitive   = true
}

variable "cloudflare_access_oidc_client_secret" {
  description = "Cloudflare Access Auth0 OIDC Client Secret"
  type        = string
  sensitive   = true
}

variable "AUTH0_DOMAIN" {
  description = "Auth0 Domain"
  type        = string
  sensitive   = true
}
variable "AUTH0_CLIENT_ID" {
  description = "Auth0 Client ID"
  type        = string
  sensitive   = true
}
variable "AUTH0_CLIENT_SECRET" {
  description = "Auth0 Client Secret"
  type        = string
  sensitive   = true
}
variable "MAX_LOGINS_WITHOUT_PASSKEY" {
  description = "Maximum number of logins without a passkey before enforcement"
  type        = string
  sensitive   = true
}
