# Cloudflare Access

# Auth0 client for Cloudflare Access OIDC Provider
data "auth0_client" "cloudflare_access" {
  client_id = var.auth0_client_cloudflare_access_id
}

## Zero Trust Auth0 OIDC Provider
resource "cloudflare_zero_trust_access_identity_provider" "oidc_provider" {
  zone_id = var.cf_zone_id
  name = "Auth0 OpenID Connect"
  type = "oidc"

  config = {
    client_id = data.auth0_client.cloudflare_access.client_id
    client_secret = data.auth0_client.cloudflare_access.client_secret
    auth_url = "https://${var.AUTH0_DOMAIN}/authorize"
    token_url = "https://${var.AUTH0_DOMAIN}/oauth/token"
    certs_url = "https://${var.AUTH0_DOMAIN}/.well-known/jwks.json"
    pkce_enabled = true
    scopes = [
      "openid",
      "email",
      "profile"
    ]
  }
}

## Zero Trust Access policy to allow epicpatka@gmail.com
resource "cloudflare_zero_trust_access_policy" "allow_epicpatka_policy" {
  account_id       = var.cf_account_id
  name             = "Allow epicpatka"
  decision         = "allow"
  session_duration = "15m"

  include = [{
    email = {
      email = "epicpatka@gmail.com"
    }
  }]
}

# Zero Trust Access Application for Meerkat SSH
# Allows access via Auth0 OIDC Identity Provider (IdP)
resource "cloudflare_zero_trust_access_application" "meerkat_zero_trust_access_application" {
  zone_id                     = var.cf_zone_id
  name                        = "meerkat"
  domain                      = "meerkat.patkub.vip"
  type                        = "self_hosted"
  session_duration            = "24h"

  # Instant Auth: Allow users to skip identity provider selection when only one login method is available.
  auto_redirect_to_identity   = true
  # WARP authentication identity
  allow_authenticate_via_warp = false
  # Enables automatic authentication through cloudflared.
  skip_interstitial = true

  # Allow epicpatka
  policies = [{
    id = cloudflare_zero_trust_access_policy.allow_epicpatka_policy.id
    precedence = 1
  }]

  # Auth0 OIDC Provider
  allowed_idps = [cloudflare_zero_trust_access_identity_provider.oidc_provider.id]
}
