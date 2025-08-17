# Fly.io + S3 + Custom VPN

```auth.env
# Relay
RELAY_SERVER_AUTH=${AUTH_TOKEN}

## Set this to a server URL that will be accessible to users on the private network
## The default port is 8080 unless you are running a reverse proxy.
RELAY_SERVER_URL_PREFIX=${RELAY_SERVER_URL}

# AWS S3
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=${BUCKET_REGION}
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
