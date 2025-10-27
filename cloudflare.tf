### patkub.vip - Cloudflare DNS Records

## Email Security Records
resource "cloudflare_record" "terraform_managed_resource_2303e67822a63aa3d0cf106bf4bf8dff_1" {
  content = "\"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;\""
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_3c83fc78f9c3d4dd75ac1a493acd8566_2" {
  content = "\"v=DKIM1; p=\""
  name    = "*._domainkey"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_record" "terraform_managed_resource_c708ad62537fd8978d4bab85596d609f_3" {
  content = "\"v=spf1 -all\""
  name    = "patkub.vip"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

## Cloudflare Tunnel for Meerkat SSH
resource "cloudflare_record" "terraform_managed_resource_db1a5473db6ba54f427b14ecea330414_0" {
  content = "7ddd1651-9bc3-423d-82ad-ad4b67ad75ad.cfargotunnel.com"
  name    = "meerkat"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cf_zone_id
}

### End patkub.vip - Cloudflare DNS Records


### Cloudflare Access

## Zero Trust Auth0 OIDC Provider
resource "cloudflare_zero_trust_access_identity_provider" "oidc_provider" {
  zone_id = var.cf_zone_id
  name = "Auth0 OpenID Connect"
  type = "oidc"

  config {
    client_id = "8oDQ5tzUM9nUDSpsUoxssLgS4vDAVHS3"
    client_secret = var.cloudflare_access_oidc_client_secret
    auth_url = "https://patkub.us.auth0.com/authorize"
    token_url = "https://patkub.us.auth0.com/oauth/token"
    certs_url = "https://patkub.us.auth0.com/.well-known/jwks.json"
    pkce_enabled = true
  }
}

## Zero Trust Access policy to allow epicpatka@gmail.com
resource "cloudflare_zero_trust_access_policy" "allow_epicpatka_policy" {
  zone_id          = var.cf_zone_id
  name             = "Allow epicpatka"
  decision         = "allow"
  session_duration = "15m"

  include {
    email = ["epicpatka@gmail.com"]
  }
}

# Zero Trust Access Application for Meerkat SSH
# Allows access via Auth0 OIDC Identity Provider (IdP)
resource "cloudflare_zero_trust_access_application" "meerkat_zero_trust_access_application" {
  zone_id    = var.cf_zone_id
  name       = "meerkat"
  domain     = "meerkat.patkub.vip"
  type       = "self_hosted"

  policies = [cloudflare_zero_trust_access_policy.allow_epicpatka_policy.id]

  # Auth0 OIDC Provider
  allowed_idps = [cloudflare_zero_trust_access_identity_provider.oidc_provider.id]
}

### End Cloudflare Access
