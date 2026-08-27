# Cloudflare Access Team
variable "cf_access_team" {
  description = "Cloudflare Access Team"
  type        = string
  sensitive   = false
}

# Passkey Policy Settings
variable "MAX_LOGINS_WITHOUT_PASSKEY" {
  description = "Maximum number of logins without a passkey before enforcement"
  type        = string
  sensitive   = true
}
