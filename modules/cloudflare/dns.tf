### patkub.vip - Cloudflare DNS Records

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