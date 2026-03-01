# Infrastructure target for Meerkat
# This makes Meerkat show up as a target when running "warp-cli target list"

data "cloudflare_zero_trust_tunnel_cloudflared_virtual_network" "cloudflared_virtual_network" {
  account_id = var.cf_account_id
  filter = {
    is_default = true
  }
}

# Zero Trust Infrastructure Target hostname for Meerkat
resource "cloudflare_zero_trust_access_infrastructure_target" "meerkat_infra_target" {
  account_id = var.cf_account_id
  hostname   = "meerkat"
  ip = {
    ipv4 = {
      ip_addr            = "192.168.1.38"
      virtual_network_id = data.cloudflare_zero_trust_tunnel_cloudflared_virtual_network.cloudflared_virtual_network.id
    }
  }
}

# Zero Trust Infrastructure Application for Meerkat
resource "cloudflare_zero_trust_access_application" "meerkat_infra_app" {
  account_id = var.cf_account_id
  name       = "meerkat infra"
  type       = "infrastructure"

  target_criteria = [{
    port     = 22
    protocol = "SSH"
    target_attributes = {
      "hostname" = ["meerkat"]
    }
  }]

  policies = [{
    name = "meerkat infra"

    include = [{
      email = {
        email = "epicpatka@gmail.com"
      }
    }]

    connection_rules = {
      ssh = {
        usernames = ["patrick"]
      }
    }

    decision = "allow"
  }]
}
