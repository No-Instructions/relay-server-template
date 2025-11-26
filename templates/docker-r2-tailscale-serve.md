# Docker + Cloudflare R2 + Tailscale Serve (HTTPS)

This template sets up a Relay Server using Docker with Cloudflare R2 storage, accessible via Tailscale Serve with HTTPS.

## Prerequisites

- Docker installed
- [Tailscale account](https://tailscale.com/) with admin access and Tailscale Serve enabled
- [Cloudflare R2](https://developers.cloudflare.com/r2/) bucket and API credentials

## Setup Instructions

### 1. Create the configuration file

Create a file named **`relay.toml`** in your project directory:

```toml
[server]
host = "0.0.0.0"
port = 8080

# Set this to your Tailscale Serve URL (will be HTTPS)
# url = "https://relay-server.YOUR-TAILNET.ts.net"

[store]
type = "cloudflare"
account_id = "YOUR_CLOUDFLARE_ACCOUNT_ID"  # Replace with your Cloudflare account ID
bucket = "YOUR-BUCKET-NAME"               # Replace with your R2 bucket name
prefix = ""                               # Optional: path prefix within bucket

# Relay.md public keys (do not change these)
[[auth]]
key_id = "relay_2025_10_22"
public_key = "/6OgBTHaRdWLogewMdyE+7AxnI0/HP3WGqRs/bYBlFg="

[[auth]]
key_id = "relay_2025_10_23"
public_key = "fbm9JLHrwPpST5HAYORTQR/i1VbZ1kdp2ZEy0XpMbf0="
```

### 2. Create the environment file

Create a file named **`auth.env`** with your credentials:

```bash
# Tailscale - Get this from https://login.tailscale.com/admin/settings/keys
TAILSCALE_AUTHKEY=tskey-auth-XXXXXX-XXXXXXXXX

# Enable userspace networking and Tailscale Serve for HTTPS
TAILSCALE_USERSPACE_NETWORKING=true
TAILSCALE_SERVE=true

# Cloudflare R2 - Get these from Cloudflare R2 > Manage R2 API Tokens
AWS_ACCESS_KEY_ID=your-r2-access-key-id
AWS_SECRET_ACCESS_KEY=your-r2-secret-access-key
```

### 3. Update your configuration

1. **Replace placeholders** in `relay.toml`:
   - `YOUR_CLOUDFLARE_ACCOUNT_ID`: Found in Cloudflare dashboard sidebar
   - `YOUR-BUCKET-NAME`: Your R2 bucket name

2. **Get your Tailscale Serve URL**:
   - After first run, check container logs for the Tailscale Serve URL
   - Update the `url` field in `relay.toml` with your HTTPS URL

### 4. Run the server

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  -v ./relay.toml:/app/relay.toml \
  docker.system3.md/relay-server
```

### 5. Get your server URL

After the container starts, find your Tailscale Serve URL:

```bash
# Check container logs for Tailscale Serve URL
docker logs relay-server

# The URL will be automatically generated as HTTPS
# Example: https://relay-server.YOUR-TAILNET.ts.net
```

Update the `url` field in `relay.toml` with your actual Tailscale Serve URL, then restart:

```bash
docker restart relay-server
```

### 6. Register with Obsidian

1. Open Obsidian
2. Run the command: **Relay: Register self-hosted relay server**
3. Enter your server URL: `https://relay-server.YOUR-TAILNET.ts.net`
