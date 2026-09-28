# Cloudflare Gateway

data "cloudflare_zero_trust_gateway_categories_list" "categories" {
  account_id = var.cf_account_id
}

locals {
  # main category to list of all subcategory ids
  # category name => category id
  category_ids = {
    for c in data.cloudflare_zero_trust_gateway_categories_list.categories.result :
    c.name => c.id
  }

  # category name => { subcategory name => id }
  categories_map = {
    for c in data.cloudflare_zero_trust_gateway_categories_list.categories.result :
    c.name => { for s in coalesce(c.subcategories, []) : s.name => s.id }
  }

  # subcategory name => id (across all categories)
  subcategories_ids = merge(values(local.categories_map)...)
}

# Network Policy to allow Access Infrastructure Target
resource "cloudflare_zero_trust_gateway_policy" "zero_trust_access_infrastructure_target" {
  account_id  = var.cf_account_id
  name        = "Access Infrastructure Target"
  description = "Access Infrastructure Target"
  precedence  = 0
  action      = "allow"
  enabled     = true
  traffic     = "access.target"
  filters     = ["l4"]
}

# DNS Policy to block ads and security risks
resource "cloudflare_zero_trust_gateway_policy" "zero_trust_block_categories" {
  account_id  = var.cf_account_id
  name        = "AdBlock"
  description = "Block ads and security risks"
  precedence  = 1
  action      = "block"
  enabled     = true
  filters     = ["dns"]
  # "Content Categories" in "Ads"
  traffic = "any(dns.content_category[*] in {${join(" ", [
    local.category_ids["Ads"],
    local.subcategories_ids["Trackers/Analytics"],
    local.subcategories_ids["Deceptive Ads"],
    local.subcategories_ids["Parked & For Sale Domains"],
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
