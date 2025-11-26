# Docker + AWS S3 + Custom VPN

This template sets up a Relay Server using Docker with AWS S3 storage, accessible via your custom VPN or private network.

## Prerequisites

- Docker installed
- Custom VPN or private network configured
- [AWS S3](https://aws.amazon.com/s3/) bucket and IAM credentials
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
type = "aws"
bucket = "YOUR-BUCKET-NAME"          # Replace with your S3 bucket name
region = "us-east-1"                 # Replace with your AWS region
prefix = ""                          # Optional: path prefix within bucket

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
# AWS S3 - Get these from AWS IAM console
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=your-secret-access-key
```

### 3. Update your configuration

1. **Replace placeholders** in `relay.toml`:
   - `YOUR-BUCKET-NAME`: Your S3 bucket name
   - `us-east-1`: Your AWS region (e.g., `us-west-2`, `eu-west-1`)
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
