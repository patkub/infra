# Cloudfare Domain Overview Account ID
variable "cf_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

# Cloudfare Domain Overview API Zone ID
variable "cf_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

# Auth0 Details
variable "AUTH0_DOMAIN" {
  description = "Auth0 Domain"
  type        = string
  sensitive   = true
}
