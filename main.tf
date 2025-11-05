# Cloudflare module
module "cloudflare" {
  source = "./modules/cloudflare"

  # Cloudflare Account ID
  cf_account_id = var.cf_account_id
  # Cloudflare Domain Overview API Zone ID
  cf_zone_id = var.cf_zone_id

  # Auth0 Domain
  AUTH0_DOMAIN = var.AUTH0_DOMAIN
}

# Auth0 module
module "auth0" {
  source = "./modules/auth0"

  # Passkey Policy Settings
  # Number of logins without a passkey (min: "1")
  MAX_LOGINS_WITHOUT_PASSKEY = var.MAX_LOGINS_WITHOUT_PASSKEY
}
