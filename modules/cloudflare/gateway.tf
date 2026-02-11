# Cloudflare Gateway

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

# Cloudflare Gateway Policy to block ads and security risks
resource "cloudflare_zero_trust_gateway_policy" "zero_trust_block_categories" {
  account_id = var.cf_account_id
  name       = "AdBlock"
  description = "Block ads and security risks"
  precedence = 0
  action     = "block"
  enabled    = true
  filters    = ["dns"]
  # "Content Categories" in "Ads"
  traffic    = "any(dns.content_category[*] in {${join(" ", [
    local.subcategories_map["Advertisements"],
    local.subcategories_map["Deceptive Ads"],
    local.subcategories_map["Parked & For Sale Domains"]
  # "Security Categories" in "All security risks"
  ])}}) and any(dns.security_category[*] in {${join(" ", [
    local.subcategories_map["Anonymizer"],
    local.subcategories_map["Brand Embedding"],
    local.subcategories_map["Command and Control & Botnet"],
    local.subcategories_map["Compromised Domain"],
    local.subcategories_map["Cryptomining"],
    local.subcategories_map["DGA Domains"],
    local.subcategories_map["DNS Tunneling"],
    local.subcategories_map["Malware"],
    local.subcategories_map["Phishing"],
    local.subcategories_map["Potentially unwanted software"],
    local.subcategories_map["Private IP Address"],
    local.subcategories_map["Scam"],
    local.subcategories_map["Spam"],
    local.subcategories_map["Spyware"]
  ])}})"
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
    certificate: {
      id: data.cloudflare_zero_trust_gateway_settings.current_zero_trust_gateway_settings.settings.certificate.id
    }
  }
}

# Default Profile meerkat
# Only traffic to 192.168.1.38/32 routes through warp
# Base CIDR: 192.168.0.0/16
# Excluded CIDRs: 192.168.1.38/32
resource "cloudflare_zero_trust_device_default_profile" "zero_trust_device_default_profile" {
  account_id = var.cf_account_id
  allow_mode_switch = true
  allow_updates = false
  allowed_to_leave = true
  captive_portal = 180
  disable_auto_fallback = true
  exclude = [{
    address = "ff05::/16"
  }, {
    address = "ff04::/16"
  }, {
    address = "ff03::/16"
  }, {
    address = "ff02::/16"
  }, {
    address = "ff01::/16"
  }, {
    address = "fe80::/10"
    description = "IPv6 Link Local"
  }, {
    address = "fd00::/8"
  }, {
    address = "255.255.255.255/32"
    description = "DHCP Broadcast"
  }, {
    address = "240.0.0.0/4"
  }, {
    address = "224.0.0.0/24"
  }, {
    address = "192.168.8.0/21"
    description = "meerkat warp"
  }, {
    address = "192.168.64.0/18"
    description = "meerkat warp"
  }, {
    address = "192.168.4.0/22"
    description = "meerkat warp"
  }, {
    address = "192.168.32.0/19"
    description = "meerkat warp"
  }, {
    address = "192.168.2.0/23"
    description = "meerkat warp"
  }, {
    address = "192.168.16.0/20"
    description = "meerkat warp"
  }, {
    address = "192.168.128.0/17"
    description = "meerkat warp"
  }, {
    address = "192.168.1.64/26"
    description = "meerkat warp"
  }, {
    address = "192.168.1.48/28"
    description = "meerkat warp"
  }, {
    address = "192.168.1.40/29"
    description = "meerkat warp"
  }, {
    address = "192.168.1.39/32"
    description = "meerkat warp"
  }, {
    address = "192.168.1.36/31"
    description = "meerkat warp"
  }, {
    address = "192.168.1.32/30"
    description = "meerkat warp"
  }, {
    address = "192.168.1.128/25"
    description = "meerkat warp"
  }, {
    address = "192.168.1.0/27"
    description = "meerkat warp"
  }, {
    address = "192.168.0.0/24"
    description = "meerkat warp"
  }, {
    address = "192.0.0.0/24"
  }, {
    address = "172.16.0.0/12"
  }, {
    address = "169.254.0.0/16"
    description = "DHCP Unspecified"
  }, {
    address = "100.64.0.0/10"
  }, {
    address = "10.0.0.0/8"
  }]
  exclude_office_ips = true
  register_interface_ip_with_dns = true
  sccm_vpn_boundary_support = false
  service_mode_v2 = {
    mode = "warp"
  }
  switch_locked = false
  tunnel_protocol = "wireguard"
}
