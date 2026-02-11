### patkub.vip - Cloudflare DNS Records

## Email Security Records
resource "cloudflare_dns_record" "cloudflare_dns_record_email_1" {
  content = "\"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;\""
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_dns_record" "cloudflare_dns_record_email_2" {
  content = "\"v=DKIM1; p=\""
  name    = "*._domainkey"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

resource "cloudflare_dns_record" "cloudflare_dns_record_email_3" {
  content = "\"v=spf1 -all\""
  name    = "patkub.vip"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cf_zone_id
}

## Cloudflare Tunnel for Meerkat SSH
resource "cloudflare_dns_record" "cloudflare_dns_record_meerkat_ssh" {
  content = "${cloudflare_zero_trust_tunnel_cloudflared.meerkat_zero_trust_tunnel_cloudflared.id}.cfargotunnel.com"
  name    = "meerkat"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cf_zone_id
}

### End patkub.vip - Cloudflare DNS Records
