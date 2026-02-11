# Device Profiles

# WARP Connector profile
resource "cloudflare_zero_trust_device_custom_profile" "example_zero_trust_device_custom_profile" {
  account_id = var.cf_account_id
  match = "identity.email == \"warp_connector@epicpatka.cloudflareaccess.com\""
  name = "WARP Connector"
  precedence = 100
  allow_mode_switch = true
  allow_updates = true
  allowed_to_leave = true
  auto_connect = 0
  captive_portal = 180
  description = "Policy for WARP Connector"
  disable_auto_fallback = true
  enabled = true
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
    address = "192.168.0.0/16"
  }, {
    address = "192.0.0.0/24"
  }, {
    address = "172.16.0.0/12"
  }, {
    address = "169.254.0.0/16"
    description = "DHCP Unspecified"
  }, {
    address = "100.88.0.0/13"
    description = "WARP Connector"
  }, {
    address = "100.84.0.0/14"
    description = "WARP Connector"
  }, {
    address = "100.82.0.0/15"
    description = "WARP Connector"
  }, {
    address = "100.81.0.0/16"
    description = "WARP Connector"
  }, {
    address = "100.64.0.0/12"
    description = "WARP Connector"
  }, {
    address = "100.112.0.0/12"
    description = "WARP Connector"
  }, {
    address = "10.0.0.0/8"
  }]
  exclude_office_ips = true
  lan_allow_minutes = 30
  lan_allow_subnet_size = 24
  register_interface_ip_with_dns = true
  sccm_vpn_boundary_support = false
  service_mode_v2 = {
    mode = "warp"
  }
  support_url = "https://1.1.1.1/help"
  switch_locked = true
  tunnel_protocol = "wireguard"
}
# End Warp Connector profile

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
# End Default Profile meerkat
