# Hosting a Relay Server on fly.io

fly.io is a great option for self-hosting a Relay Server.

## Prerequisites

- [flyctl](https://fly.io/docs/hands-on/install-flyctl/) installed and authenticated
- A secret token from the Relay team (email daniel@system3.md or find us on [discord](https://discord.system3.md).
- An AWS S3 bucket (or Cloudflare R2)


## Choose your private network configuration

### Tailscale & Cloudflare R2 (recommended)
[Tailscale (http) with R2](templates/fly-r2-tailscale.md)
[Tailscale (https) with R2](templates/fly-r2-tailscale-serve.md)

### Tailscale & AWS S3
[Tailscale (http) with S3](templates/fly-s3-tailscale.md)
[Tailscale (https) with S3](templates/fly-s3-tailscale-serve.md)

### Custom VPN
[Custom VPN with S3](templates/fly-s3-custom.md)
[Custom VPN with R2](templates/fly-r2-custom.md)


### Using the .flycast private network as a VPN
It is possible to use your fly network as a private network for your Relay Server.
In this configuration you will connect to your fly.io network via wireguard.

#### Configure with Fly Wireguard

```
flyctl wireguard create \
    personal \  # your fly.io org
    sjc         # choose a region close to you

sudo mv fly.conf /etc/wireguard/
sudo chown root:root /etc/wireguard/fly.conf
```

#### Connect
```
sudo wg-quick up fly
```


### Releasing public IPs
By default, `flyctl deploy` can allocate public IP addresses.
Remove the public IP addresses to ensure that your app is not routable on the public internet.

```
flyctl ips list
# VERSION	IP                    	TYPE              	REGION	CREATED AT       
# v6     	<your public ipv6>    	public (dedicated)	global	28m36s ago      	
# v4     	<your public ipv4>    	public (shared)   	      	Jan 1 0001 00:00

flyctl ips release <your public ipv6>
flyctl ips release <your public ipv4>
```

### Deploying to .flycast
Deploying with `--flycast` will allocate you app a private ipv6 address and make it routeable within your fly network.
```
fly secrets set RELAY_SERVER_URL_PREFIX=http://$APP_NAME.flycast:8080
fly deploy --flycast
```
