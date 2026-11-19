# Cloudflare Account API Token ( https://developers.cloudflare.com/fundamentals/api/get-started/account-owned-tokens/ )
variable "cf_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

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

  validation {
    condition     = can(regex("^[1-9][0-9]*$", var.MAX_LOGINS_WITHOUT_PASSKEY))
    error_message = "MAX_LOGINS_WITHOUT_PASSKEY must be a positive whole number (e.g. \"3\")."
  }
}
