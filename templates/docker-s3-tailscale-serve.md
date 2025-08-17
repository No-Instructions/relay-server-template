# Docker + S3 + Tailscale with Tailscale Server (https)

```auth.env
# Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}
RELAY_SERVER_URL_PREFIX=https://relay-server.${TAILNET_NAME}.ts.net

# Tailscale
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}
TAILSCALE_USERSPACE_NETWORKING=true
TAILSCALE_SERVE=true

# AWS S3
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=${BUCKET_REGION}
STORAGE_BUCKET=${BUCKET}
RELAY_SERVER_STORE=s3://${BUCKET}/
```

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  docker.system3.md/relay-server
```
