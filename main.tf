# Auth0 module
module "auth0" {
  source = "./modules/auth0"

  # Passkey Policy Settings
  # Number of logins without a passkey (min: "1")
  MAX_LOGINS_WITHOUT_PASSKEY = var.MAX_LOGINS_WITHOUT_PASSKEY
}

# Cloudflare module
module "cloudflare" {
  source     = "./modules/cloudflare"
  depends_on = [module.auth0]

  # Auth0 Client ID for Cloudflare Access OIDC Client
  auth0_client_cloudflare_access_id = module.auth0.auth0_client_cloudflare_access_id

  # Cloudflare Account ID
  cf_account_id = var.cf_account_id
  # Cloudflare Domain Overview API Zone ID
  cf_zone_id = var.cf_zone_id
}
