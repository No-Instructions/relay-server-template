# Docker + R2 + Custom VPN

```toml
# relay.toml
[server]
host = "0.0.0.0"
port = 8080

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
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
```

```bash
docker run -d \
  --name relay-server \
  --env-file auth.env \
  -v ./relay.toml:/app/relay.toml \
  -p 8080:8080 \
  docker.system3.md/relay-server https://relay-server.private.network
```
