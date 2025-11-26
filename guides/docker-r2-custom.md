# Docker + Cloudflare R2 + Custom VPN

This template sets up a Relay Server using Docker with Cloudflare R2 storage, accessible via your custom VPN or private network.

## Prerequisites

- Docker installed
- Custom VPN or private network configured
- [Cloudflare R2](https://developers.cloudflare.com/r2/) bucket and API credentials
- Static IP or hostname on your private network

## Setup Instructions

### 1. Create the configuration file

Create a file named **`relay.toml`** in your project directory:

```toml
[server]
host = "0.0.0.0"
port = 8080

# Set this to your private network URL
# url = "http://YOUR-PRIVATE-IP:8080"
# or url = "https://relay.your-domain.internal"

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
# Cloudflare R2 - Get these from Cloudflare R2 > Manage R2 API Tokens
AWS_ACCESS_KEY_ID=your-r2-access-key-id
AWS_SECRET_ACCESS_KEY=your-r2-secret-access-key
```

### 3. Update your configuration

1. **Replace placeholders** in `relay.toml`:
   - `YOUR_CLOUDFLARE_ACCOUNT_ID`: Found in Cloudflare dashboard sidebar
   - `YOUR-BUCKET-NAME`: Your R2 bucket name
   - `YOUR-PRIVATE-IP`: The private IP of the server running Docker

2. **Choose your URL format**:
   - HTTP: `http://YOUR-PRIVATE-IP:8080`
   - HTTPS with custom domain: `https://relay.your-domain.internal`

### 4. Run the server

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  -v ./relay.toml:/app/relay.toml \
  -p 8080:8080 \
  docker.system3.md/relay-server
```

### 5. Configure your private network

Ensure the server is accessible on your private network:

```bash
# Test connectivity from a client machine on your VPN
curl http://YOUR-PRIVATE-IP:8080/health
```

### 6. Register with Obsidian

1. Open Obsidian on a device connected to your VPN
2. Run the command: **Relay: Register self-hosted relay server**
3. Enter your server URL: `http://YOUR-PRIVATE-IP:8080`
