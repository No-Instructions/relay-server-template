# Docker + R2 + Tailscale (http)

```auth.env
# Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}
RELAY_SERVER_URL_PREFIX=http://relay-server.${TAILNET_NAME}.ts.net:8080

# Tailscale
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}
TAILSCALE_USERSPACE_NETWORKING=true

# Cloudflare R2
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=auto
STORAGE_BUCKET=${BUCKET}
AWS_ENDPOINT_URL_S3=https://${CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com
RELAY_SERVER_STORE=s3://${BUCKET}/

```

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  docker.system3.md/relay-server
```
