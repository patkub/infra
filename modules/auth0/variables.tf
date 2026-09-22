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

  validation {
    condition     = can(regex("^[1-9][0-9]*$", var.MAX_LOGINS_WITHOUT_PASSKEY))
    error_message = "MAX_LOGINS_WITHOUT_PASSKEY must be a positive whole number (e.g. \"3\")."
  }
}
