# Fly.io + AWS S3 + Custom VPN

This template sets up a Relay Server on Fly.io with AWS S3 storage, accessible via your custom VPN or private network using Fly.io's private networking.

## Prerequisites

- [Fly.io account](https://fly.io/) and `flyctl` installed
- Custom VPN or private network configured with Fly.io WireGuard
- [AWS S3](https://aws.amazon.com/s3/) bucket and IAM credentials

## Setup Instructions

### 1. Create the configuration file

Create a file named **`relay.toml`** in your project directory:

```toml
[server]
host = "0.0.0.0"
port = 8080

# Set this to your Fly.io app's private URL
# url = "http://YOUR-APP-NAME.flycast:8080"

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
   - In `relay.toml`: Update `YOUR-BUCKET-NAME` and AWS region
   - In `fly.toml`: Update `YOUR-APP-NAME` and preferred region

2. **Create the Fly.io app**:
   ```bash
   flyctl apps create YOUR-APP-NAME
   ```

### 6. Deploy to Fly.io with private networking

```bash
flyctl deploy \
    --file-secret auth.env \
    --flycast
```

### 7. Set up WireGuard VPN access

Connect to your Fly.io private network:

```bash
# Create WireGuard configuration
flyctl wireguard create personal sjc

# Move configuration and connect
sudo mv fly.conf /etc/wireguard/
sudo wg-quick up fly
```

### 8. Get your server URL

Your app will be available at:
```
http://YOUR-APP-NAME.flycast:8080
```

Update the `url` field in `relay.toml`, then redeploy:

```bash
flyctl deploy --file-secret auth.env --flycast
```

### 9. Register with Obsidian

1. Ensure you're connected to the Fly.io WireGuard network
2. Open Obsidian
3. Run the command: **Relay: Register self-hosted relay server**
4. Enter your server URL: `http://YOUR-APP-NAME.flycast:8080`
