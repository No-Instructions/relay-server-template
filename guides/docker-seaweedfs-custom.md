# Docker + SeaweedFS + Custom VPN

This template sets up a Relay Server using Docker with SeaweedFS storage, which has an S3-compatible API, accessible via your custom VPN or private network.

## Prerequisites

- Docker installed
- Custom VPN or private network configured
- [SeaweedFS](https://seaweedfs.com/) bucket and IAM credentials
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
bucket = "YOUR-BUCKET-NAME"          # Replace with your SeaweedFS bucket name
region = "us-east-1"                 # Doesn't matter for self-hosted SeaweedFS
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
# Specify your access key / secret key for accessing the SeaweedFS bucket.
# You can create a new user on your SeaweedFS cluster from `weed shell`:
# `s3.configure -user=relay -access_key=relay -secret_key=CHANGEME -actions=Admin,Read,Write,List,Tagging -apply`
AWS_ACCESS_KEY_ID=relay
AWS_SECRET_ACCESS_KEY=your-secret-access-key

# Needed to send requests to your SeaweedFS S3-compatible API
# instead of AWS S3 public APIs.
# Set this to your private endpoint for SeaweedFS
# AWS_ENDPOINT_URL_S3=http://YOUR-SEAWEEDFS-IP:8333"
# or
# AWS_ENDPOINT_URL_S3=https://seaweed.your-domain.internal""
```

### 3. Update your configuration

1. **Replace placeholders** in `relay.toml`:
   - `YOUR-BUCKET-NAME`: Your SeaweedFS bucket name
   - `YOUR-PRIVATE-IP`: The private IP of the server running Docker

2. **Replace placeholders** in `auth.env`:
   - `YOUR-SEAWEEDFS-IP`: The private IP of the server running SeaweedFS
   - `your-secret-access-key`: The secret key you created on SeaweedFS

2. **Choose your URL format**:
   - HTTP: `http://YOUR-PRIVATE-IP:8080`
   - HTTPS with custom domain: `https://relay.your-domain.internal`
   - Likewise with the SeaweedFS server URL

### 4. Run the server

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  -v ./relay.toml:/app/relay.toml \
  -p 8080:8080 \
  docker.system3.md/relay-server
```

Or using docker compose: 

```yaml
services:
  relay-server:
    image: docker.system3.md/relay-server
    container_name: relay-server
    env_file:
      - auth.env
    volumes:
      - ./relay.toml:/app/relay.toml
    ports:
      - "8080:8080"
    restart: always
```

### 5. Configure your private network

Ensure the server is accessible on your private network:

```bash
# Test connectivity from a client machine on your VPN
curl -i http://YOUR-PRIVATE-IP:8080/ready
```

### 6. Register with Obsidian

1. Open Obsidian on a device connected to your VPN
2. Run the command: **Relay: Register self-hosted relay server**
3. Enter your server URL: `http://YOUR-PRIVATE-IP:8080`
