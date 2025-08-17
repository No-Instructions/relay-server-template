# Fly.io + S3 + Tailscale with Tailscale Serve (https)

```auth.env
# Auth Token from Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}

# Tailscale
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}
TAILSCALE_SERVE=true

# AWS S3
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=${BUCKET_REGION}
STORAGE_BUCKET=${BUCKET}
RELAY_SERVER_STORE=s3://${BUCKET}/

RELAY_SERVER_URL_PREFIX=https://relay-server.${TAILNET_NAME}.ts.net
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
