# Infrastructure

Cloudflare Access secured with Auth0 and PassKey only login

## Description

Terraform configuration for my infrastructure
- Cloudflare Access is secured with Auth0
- Auth0 Action and Forms enforce login with PassKey only
- A Cloudflare tunnel accessible via SSH at [meerkat.patkub.vip](https://meerkat.patkub.vip/)

## Cloud Configuration

Create `terraform.tfvars` with:

```bash
# Cloudfare Account Email
cf_email                              = "..."
# Cloudfare Global API Key ( https://dash.cloudflare.com/profile/api-tokens )
cf_api_key                            = "..."
# Cloudfare Domain Overview API Zone ID
cf_zone_id                            = "..."

# Auth0 M2M Application Details
AUTH0_DOMAIN                          = "..."
AUTH0_CLIENT_ID                       = "..."
AUTH0_CLIENT_SECRET                   = "..."

# Passkey Policy Settings
# Number of logins without a passkey (min: "1")
MAX_LOGINS_WITHOUT_PASSKEY            = "3"
```

Run:

```bash
terraform init
terraform apply
```

## Server Configuration

Follow
- [Short-lived certificates (legacy)](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/short-lived-certificates-legacy/)
- [Connect to SSH with client-side cloudflared (legacy)](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-cloudflared-authentication/)

Configure server with:

```bash
chmod +x ./src/server/install.sh
./src/server/install.sh
```

### Individual Scripts
- `./src/server/sshd/sshd.sh` - Setup sshd for Meerkat


## Client Configuration

Reference: [Connect to SSH with client-side cloudflared (legacy)](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-cloudflared-authentication/)


Configure client devices with:

```bash
chmod +x ./src/client/install.sh
./src/client/install.sh
```

- Adds client-side cloudflared SSH host for meerkat
- Patches SDKMAN! to automatically import Cloudflare Zero Trust certificate when installing a Java JDK

### Individual Scripts
- `./src/client/ssh/ssh.sh` - Adds SSH host for meerkat
- `./src/client/sdkman/patch.sh` - Patches SDKMAN!

## Dev Setup

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

