# Fly.io + Cloudflare R2 + Tailscale (HTTP)

This template sets up a Relay Server on Fly.io with Cloudflare R2 storage, accessible via Tailscale private network.

## Prerequisites

- [Fly.io account](https://fly.io/) and `flyctl` installed
- [Tailscale account](https://tailscale.com/) with admin access
- [Cloudflare R2](https://developers.cloudflare.com/r2/) bucket and API credentials

## Setup Instructions

### 1. Create the configuration file

Create a file named **`relay.toml`** in your project directory:

```toml
[server]
host = "0.0.0.0"
port = 8080

# Set this to your Fly.io app URL with Tailscale
# url = "http://YOUR-APP-NAME.flycast:8080"

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

# Cloudflare R2 - Get these from Cloudflare R2 > Manage R2 API Tokens
AWS_ACCESS_KEY_ID=your-r2-access-key-id
AWS_SECRET_ACCESS_KEY=your-r2-secret-access-key
```

### 3. Create the Dockerfile

Create a file named **`Dockerfile`**:

```dockerfile
FROM docker.system3.md/relay-server:latest
COPY relay.toml /app/relay.toml
```

### 4. Create the Fly.io configuration

Create a file named **`fly.toml`**:

```toml
app = 'YOUR-APP-NAME'              # Replace with your chosen app name

primary_region = 'sjc'             # Replace with your preferred region
kill_signal = 'SIGTERM'
kill_timeout = '5m0s'

[build]
  dockerfile = "Dockerfile"

[experimental]
  auto_rollback = true
  max_per_region = 1

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = 'stop'
  auto_start_machines = true
  min_machines_running = 0
  processes = ['app']

[[vm]]
  memory = '256mb'
  cpu_kind = 'shared'
  cpus = 1
```

### 5. Update your configuration

1. **Replace placeholders**:
   - In `relay.toml`: Update Cloudflare account ID and bucket name
   - In `fly.toml`: Update `YOUR-APP-NAME` and preferred region

2. **Create the Fly.io app**:
   ```bash
   flyctl apps create YOUR-APP-NAME
   ```

### 6. Deploy to Fly.io

```bash
flyctl deploy \
    --file-secret auth.env \
    --flycast
```

### 7. Get your server URL

After deployment, your app will be available at:
```
http://YOUR-APP-NAME.flycast:8080
```

Update the `url` field in `relay.toml` with this URL, then redeploy:

```bash
flyctl deploy --file-secret auth.env --flycast
```

### 8. Register with Obsidian

1. Connect to your Fly.io network via Tailscale or Fly.io WireGuard
2. Open Obsidian
3. Run the command: **Relay: Register self-hosted relay server**
4. Enter your server URL: `http://YOUR-APP-NAME.flycast:8080`
