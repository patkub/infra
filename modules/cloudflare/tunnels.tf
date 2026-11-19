# Tunnels

# meerkat cloudflared
resource "cloudflare_zero_trust_tunnel_cloudflared" "meerkat_zero_trust_tunnel_cloudflared" {
  account_id = var.cf_account_id
  name       = "meerkat"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "meerkat_zero_trust_tunnel_cloudflared_config" {
  account_id = var.cf_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.meerkat_zero_trust_tunnel_cloudflared.id
  config = {
    ingress = [
      # SSH
      {
        hostname = "meerkat.patkub.vip"
        service  = "ssh://localhost:22"
        origin_request = {
          access = {
            aud_tag   = [cloudflare_zero_trust_access_application.meerkat.aud]
            team_name = var.cf_access_team
            required  = true
          }
          connect_timeout = 10
        },
      },
      {
        service = "http_status:404"
      }
    ]
  }
}
# End meerkat cloudflared

# meerkat-warp WARP
resource "cloudflare_zero_trust_tunnel_warp_connector" "meerkat_warp_zero_trust_tunnel_warp_connector" {
  account_id = var.cf_account_id
  name       = "meerkat-warp"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "meerkat_zero_trust_tunnel_cloudflared_route" {
  account_id = var.cf_account_id
  network    = "192.168.1.38/32"
  tunnel_id  = cloudflare_zero_trust_tunnel_warp_connector.meerkat_warp_zero_trust_tunnel_warp_connector.id
  comment    = "My private network"
}
# End meerkat-warp WARP
