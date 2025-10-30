# Fly.io + R2 + Tailscale with Tailscale Serve (https)

```toml
# relay.toml
[server]
host = "0.0.0.0"
port = 8080

# Set this to the private URL of your Relay Server
# url = http://${FLY_APP_NAME}.flycast:8080

[store]
type = "cloudflare"
account_id = "abc123..."
bucket = "my-bucket"
prefix = ""                  # Optional path prefix within bucket

# Relay.md public keys
[[auth]]
key_id = "relay_2025_10_22"
public_key = "/6OgBTHaRdWLogewMdyE+7AxnI0/HP3WGqRs/bYBlFg="

[[auth]]
key_id = "relay_2025_10_23"
public_key = "fbm9JLHrwPpST5HAYORTQR/i1VbZ1kdp2ZEy0XpMbf0="
```

```auth.env
# Tailscale
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY}
TAILSCALE_USERSPACE_NETWORKING=true
TAILSCALE_SERVE=true

# Cloudflare R2
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
```

```Dockerfile
FROM docker.system3.md/relay-server:latest
COPY relay.toml /app/relay.toml
```

```fly.toml
app = '${FLY_APP_NAME}'

primary_region = '${FLY_REGION}'  # flyctl platform regions
kill_signal = 'SIGTERM'
kill_timeout = '5m0s'

[build]
  dockerfile = Dockerfile

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
