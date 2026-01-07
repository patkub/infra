# Infrastructure

Cloudflare Access secured with Auth0 and PassKey only login

## Overview

Terraform configuration for my infrastructure
- Cloudflare Access is secured with Auth0
- Auth0 Action and Forms enforce login with PassKey only
- A DNS based Adblock policy
- A Cloudflare tunnel accessible via SSH at [meerkat.patkub.vip](https://meerkat.patkub.vip/)

### Description

Cloudflare Access secured with Auth0 and PassKey only login deployed using Terraform configuration.

I setup Cloudflare Zero Trust Access to authenticate using an Auth0 OpenID Connect (OIDC) application. In Auth0, I have a custom Post-Login Action that requires the user to use a PassKey to sign-in. PassKeys are free, while traditional OTP MFA is a paid feature.

In Cloudflare Zero Trust, I have a DNS based Adblock policy, and an SSH tunnel protected by short-lived SSH certificates.

This lets me SSH/VNC into my PC from anywhere using PassKeys, without exposing ports nor managing SSH keys!

## Cloud Configuration

Reference `terraform.tfvars.example`.

Create `terraform.tfvars` with:

```bash
# Cloudflare Account Email
cf_email                            = "..."
# Cloudflare Global API Key ( https://dash.cloudflare.com/profile/api-tokens )
cf_api_key                          = "..."
# Cloudflare Domain Overview Account ID
cf_account_id                       = "..."
# Cloudflare Domain Overview API Zone ID
cf_zone_id                          = "..."

# Auth0 M2M Application Details
AUTH0_DOMAIN                        = "..."
AUTH0_CLIENT_ID                     = "..."
AUTH0_CLIENT_SECRET                 = "..."

# Passkey Policy Settings
# Number of logins without a passkey (min: "1")
MAX_LOGINS_WITHOUT_PASSKEY          = "3"
```

Run:

```bash
terraform init
terraform apply
```

## Server Configuration

Follow: [Short-lived certificates (legacy)](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/short-lived-certificates-legacy/)

Configure server with:

```bash
chmod +x ./scripts/server/install.sh
./scripts/server/install.sh
```

### Individual Scripts
- `./scripts/server/sshd/sshd.sh` - Setup sshd for Meerkat


## Client Configuration

Reference: [Connect to SSH with client-side cloudflared (legacy)](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-cloudflared-authentication/)


Configure client devices with:

```bash
chmod +x ./scripts/client/install.sh
./scripts/client/install.sh
```

- Adds client-side cloudflared SSH host for meerkat
- Adds Cloudflare Zero Trust certificate to npmrc
- Patches SDKMAN! to automatically import Cloudflare Zero Trust certificate when installing a Java JDK

### Individual Scripts
- `./scripts/client/ssh/ssh.sh` - Adds SSH host for meerkat
- `./scripts/client/npm/npm.sh` - Configures npmrc
- `./scripts/client/sdkman/patch.sh` - Patches SDKMAN!

## Dev Setup

[Node.js v22 LTS](https://nodejs.org/en/download), [pnpm](https://pnpm.io/installation)

Install dependencies

```bash
pnpm install
```

Lint
- `pnpm lint` - Lint with biome and apply changes
- `pnpm lint:check` - Check linting with biome
- `pnpm format` - Format with biome and apply changes
- `pnpm format:check` - Check formatting with biome

Run tests
- `pnpm test` - Run unit tests
- `pnpm test:watch` - Automatically re-run tests when files change

