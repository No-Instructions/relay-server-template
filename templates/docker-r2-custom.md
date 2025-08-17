# Docker + R2 + Custom VPN

```auth.env
# Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}

## Set this to a server URL that will be accessible to users on the private network
## The default port is 8080 unless you are running a reverse proxy.
RELAY_SERVER_URL_PREFIX=${RELAY_SERVER_URL}

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
  -p 8080:8080 \
  docker.system3.md/relay-server
```
