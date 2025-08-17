# Fly.io + R2 + Tailscale (http)

```auth.env
# Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}
RELAY_SERVER_URL_PREFIX=http://relay-server.${TAILNET_NAME}.ts.net:8080

# Tailscale
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}

# Cloudflare R2
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=auto
STORAGE_BUCKET=${BUCKET}
AWS_ENDPOINT_URL_S3=https://${CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com
RELAY_SERVER_STORE=s3://${BUCKET}/
```

```fly.toml
app = '${FLY_APP_NAME}'
primary_region = '${FLY_REGION}'  # flyctl platform regions
kill_signal = 'SIGTERM'
kill_timeout = '5m0s'

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

```bash
flyctl deploy \
    --file-secret auth.env \
    --flycast  # private networking only
```
