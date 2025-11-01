### patkub.vip - Cloudflare DNS Records

# Required Providers
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = ">= 1.0.0"
    }
  }
}

## Email Security Records
resource "cloudflare_dns_record" "cloudflare_dns_record_1" {
  content = "\"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;\""
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_dns_record" "cloudflare_dns_record_2" {
  content = "\"v=DKIM1; p=\""
  name    = "*._domainkey"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_dns_record" "cloudflare_dns_record_3" {
  content = "\"v=spf1 -all\""
  name    = "patkub.vip"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

## Cloudflare Tunnel for Meerkat SSH
resource "cloudflare_dns_record" "cloudflare_dns_record_meerkat_ssh" {
  content = "7ddd1651-9bc3-423d-82ad-ad4b67ad75ad.cfargotunnel.com"
  name    = "meerkat"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cf_zone_id
}

### End patkub.vip - Cloudflare DNS Records


### Cloudflare Access

# Auth0 client for Cloudflare Access OIDC Provider
data "auth0_client" "cloudflare_access" {
  name = "Cloudflare Access"
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

  # Allow epicpatka
  policies = [{
    id = cloudflare_zero_trust_access_policy.allow_epicpatka_policy.id
    precedence = 1
  }]

  # Auth0 OIDC Provider
  allowed_idps = [cloudflare_zero_trust_access_identity_provider.oidc_provider.id]
}

### End Cloudflare Access

### Cloudflare Gateway

data "cloudflare_zero_trust_gateway_categories_list" "categories" {
  account_id = var.cf_account_id
}

locals {
  main_categories_map = {
    for idx, c in data.cloudflare_zero_trust_gateway_categories_list.categories.result :
    c.name => c.id
  }

  subcategories_map = merge(flatten([
    for idx, c in data.cloudflare_zero_trust_gateway_categories_list.categories.result : {
      for k, v in coalesce(c.subcategories, []) :
      v.name => v.id
    }
  ])...)
}

# Cloudflare Gateway Policy to block Ads Categories
resource "cloudflare_zero_trust_gateway_policy" "zero_trust_block_ads_categories" {
  account_id = var.cf_account_id
  name       = "Block Ads"
  description = "Block Deceptive Ads, and Parked & For Sale Domains"
  precedence = 0
  action     = "block"
  enabled    = true
  filters    = ["dns"]
  traffic    = "any(dns.content_category[*] in {${join(" ", [
    local.subcategories_map["Advertisements"],
    local.subcategories_map["Deceptive Ads"],
    local.subcategories_map["Parked & For Sale Domains"]
  ])}})"
}

# Cloudflare Gateway Policy to Disable Logging and Enable TLS Decryption
data "cloudflare_zero_trust_gateway_settings" "current_zero_trust_gateway_settings" {
  account_id = var.cf_account_id
}
resource "cloudflare_zero_trust_gateway_settings" "zero_trust_gateway_settings" {
  account_id = var.cf_account_id
  settings = {
    activity_log = {
      enabled = false
    }
    tls_decrypt = {
      enabled = true
    }
    # Use existing certificate
    certificate: {
      id: data.cloudflare_zero_trust_gateway_settings.current_zero_trust_gateway_settings.settings.certificate.id
    }
  }
}

### End Cloudflare Gateway
