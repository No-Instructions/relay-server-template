# Hosting an on-premise Relay Server

[Relay](https://relay.md) supports self-hosting your Relay Server for added privacy.

If you host your own Relay Server it provides you with full privacy for your documents and attachments.

Relay's Control Plane handles login and permissions management, but is unable to read the contents of your documents.


## Security Architecture

![Security Architecture](architecture.png)

Self-hosted Relay Servers rely on public key cryptography to trust tokens that are issued by the Relay Control Plane.

It is technically possible for the Relay control plane to issue an access token and then use it to connect to your Relay Server if it is hosted on the public internet.

**To ensure that your documents are fully private, you need to host your Relay Server on a private network such as a tailscale tailnet or a corporate VPN.**

**If you don't already have a private network set up, we recommend using tailscale.**

**If you host your Relay Server on the public internet, we reserve the right to drop it from our network.**


## Choose Your Setup

Before getting started, you need to make three key decisions:

### 1. Storage Provider
Choose where to store your data:

S3-Compatible storage providers:
- **AWS S3**
- **Cloudflare R2** - Easiest to set up
- **Backblaze B2**
- **Tigris** - Great for Fly.io deployments

Local Disk (not recommended for production)

### 2. Network Access
Choose how users will access your server:
- **Tailscale** - ✅ **Recommended**: Private VPN, easy setup, secure
- **Custom VPN** - Use your existing corporate VPN
- **Public Internet** - ⚠️ **Not recommended**: Less secure, not private to us

### 3. Hosting Platform
Choose where to run your server:
- **Docker/Docker Compose** - Local or VPS deployment
- **Fly.io** - Cloud provider with a great developer experience
- **Kubernetes** - Enterprise container orchestration

## Getting Started

1. **Pick your deployment guide**: See [Deployment Guides](#deployment-guides) section below based on your choices above

2. **Follow the deployment guide instructions**: Each deployment guide includes complete setup steps

3. **Register your Relay Server**: Open Obsidian and run the command `Relay: Register self-hosted relay server`

## Contact

Join our community on discord: [https://discord.system3.md](https://discord.system3.md)

Or email: daniel@relay.md


## S3-compatible storage

Relay Server is built to store data to S3-compatible storage.
You will find examples in this repo that use:
- [AWS S3](https://aws.amazon.com/s3/)
- [Cloudflare R2](https://www.cloudflare.com/developer-platform/products/r2/)
- [Backblaze B2](https://www.backblaze.com/cloud-storage)
- [MinIO](https://min.io) (self-hosted)
- [Tigris](https://www.tigrisdata.com/docs/) (great for fly.io)

## Deployment Guides

Choose your deployment guide based on your decisions above:

### Docker (Single container)

| Storage | Network | Deployment Guide |
|---------|---------|----------|
| AWS S3 | Tailscale | [docker-s3-tailscale.md](guides/docker-s3-tailscale.md) |
| AWS S3 | Tailscale (HTTPS) | [docker-s3-tailscale-serve.md](guides/docker-s3-tailscale-serve.md) |
| AWS S3 | Custom VPN | [docker-s3-custom.md](guides/docker-s3-custom.md) |
| Cloudflare R2 | Tailscale | [docker-r2-tailscale.md](guides/docker-r2-tailscale.md) |
| Cloudflare R2 | Tailscale (HTTPS) | [docker-r2-tailscale-serve.md](guides/docker-r2-tailscale-serve.md) |
| Cloudflare R2 | Custom VPN | [docker-r2-custom.md](guides/docker-r2-custom.md) |

### Fly.io (Serverless platform)

See [Fly.io setup instructions](FLY.md) first, then choose:

| Storage | Network | Deployment Guide |
|---------|---------|----------|
| AWS S3 | Tailscale | [fly-s3-tailscale.md](guides/fly-s3-tailscale.md) |
| AWS S3 | Tailscale (HTTPS) | [fly-s3-tailscale-serve.md](guides/fly-s3-tailscale-serve.md) |
| AWS S3 | Custom VPN | [fly-s3-custom.md](guides/fly-s3-custom.md) |
| Cloudflare R2 | Tailscale | [fly-r2-tailscale.md](guides/fly-r2-tailscale.md) |
| Cloudflare R2 | Tailscale (HTTPS) | [fly-r2-tailscale-serve.md](guides/fly-r2-tailscale-serve.md) |
| Cloudflare R2 | Custom VPN | [fly-r2-custom.md](guides/fly-r2-custom.md) |

### Kubernetes (Enterprise)

| Storage | Deployment Guide |
|---------|----------|
| Tigris | [kubernetes-tigris-azure](https://github.com/No-Instructions/relay-server-template/tree/main/guides/kubernetes) |

# Acknowledgements

The Relay Collaboration Server is a fork of [y-sweet](https://github.com/jamsocket/y-sweet) by the talented folks at jamsocket.com

y-sweet builds on [y-crdt](https://github.com/y-crdt/y-crdt) by Bartosz Sypytkowski, Kevin Jahns, and the y-crdt community.

The server source code is MIT licenced and available [here](https://github.com/no-instructions/y-sweet).
