# Infrastructure

## Description

Terraform configuration for my infrastructure.

- PC connected to Cloudflare tunnel accessible at [meerkat.patkub.vip](https://meerkat.patkub.vip/)
- Access to [meerkat.patkub.vip](https://meerkat.patkub.vip/) is secured via Auth0 OIDC Client requiring device Passkey Auth

## Install

Create `terraform.tfvars` with:

```bash
# Cloudfare Account Email
cf_email                              = "..."
# Global API Key ( https://dash.cloudflare.com/profile/api-tokens )
cf_api_key                            = "..."
# Domain Overview API Zone ID
cf_zone_id                            = "..."
# Cloudflare Access Auth0 Client Secret
cloudflare_access_oidc_client_secret  = "..."

# Auth0 M2M Application Details
AUTH0_DOMAIN                          = "..."
AUTH0_CLIENT_ID                       = "..."
AUTH0_CLIENT_SECRET                   = "..."
```

Run:

```bash
terraform init
terraform apply
```

## Configure SDKMAN

Patch SDKMAN! to automatically install Cloudflare Zero Trust certificate when installing a Java JDK.

```bash
chmod +x ./sdkman/patch.sh
./sdkman/patch.sh
```
