# Cloudflare Gateway

data "cloudflare_zero_trust_gateway_categories_list" "categories" {
  account_id = var.cf_account_id
}

locals {
  # main category to list of all subcategory ids
  categories_map = {
    for idx, c in data.cloudflare_zero_trust_gateway_categories_list.categories.result :
    c.name => {
      for k, v in coalesce(c.subcategories, []) :
      v.name => v.id
    }
  }

  # subcategory to id
  subcategories_map = merge(flatten([
    for idx, c in data.cloudflare_zero_trust_gateway_categories_list.categories.result : {
      for k, v in coalesce(c.subcategories, []) :
      v.name => v.id
    }
  ])...)
}

# Cloudflare Gateway Policy to block ads and security risks
resource "cloudflare_zero_trust_gateway_policy" "zero_trust_block_categories" {
  account_id  = var.cf_account_id
  name        = "AdBlock"
  description = "Block ads and security risks"
  precedence  = 0
  action      = "block"
  enabled     = true
  filters     = ["dns"]
  # "Content Categories" in "Ads"
  traffic = "any(dns.content_category[*] in {${join(" ", [
    local.subcategories_map["Advertisements"],
    local.subcategories_map["Deceptive Ads"],
    local.subcategories_map["Parked & For Sale Domains"]
    # "Security Categories" in "All security risks"
  ])}}) and any(dns.security_category[*] in {${join(" ", values(local.categories_map["Security threats"]))}})"
}

# Cloudflare Gateway Settings
data "cloudflare_zero_trust_gateway_settings" "current_zero_trust_gateway_settings" {
  account_id = var.cf_account_id
}
resource "cloudflare_zero_trust_gateway_settings" "zero_trust_gateway_settings" {
  account_id = var.cf_account_id
  settings = {
    # Disable logging
    activity_log = {
      enabled = false
    }
    # TLS Decryption
    tls_decrypt = {
      enabled = false
    }
    # Use existing certificate
    certificate : {
      id : data.cloudflare_zero_trust_gateway_settings.current_zero_trust_gateway_settings.settings.certificate.id
    }
  }
}
