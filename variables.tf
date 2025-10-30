# Cloudfare Account Email
variable "cf_email" {
  description = "Cloudflare Account Email"
  type        = string
  sensitive   = true
}

# Cloudfare Global API Key ( https://dash.cloudflare.com/profile/api-tokens )
variable "cf_api_key" {
  description = "Cloudflare API Key"
  type        = string
  sensitive   = true
}

# Cloudfare Domain Overview API Zone ID
variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

# Auth0 M2M Application Details
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

# Passkey Policy Settings
variable "MAX_LOGINS_WITHOUT_PASSKEY" {
  description = "Maximum number of logins without a passkey before enforcement"
  type        = string
  sensitive   = true
}
