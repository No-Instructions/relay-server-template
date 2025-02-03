# Self-Hosting a Relay Collaboration Server on Fly.io

NOTE: This is experimental. Contact daniel@system3.md if you're interested in self-hosting your Relay Collaboration Server, or find us on [Discord](https://discord.system3.md).


[Relay](https://system3.md/relay) supports self-hosting your Relay Server.
While you cannot self-host the entire Relay service, self-hosting your Relay Server means that the Relay team does not have access to the contents of your documents (experimental -- some caveats at the moment).

This template helps you deploy a Relay Server on Fly.io. The server persists data to your S3 bucket.


## Prerequisites

- [flyctl](https://fly.io/docs/hands-on/install-flyctl/) installed and authenticated
- A secret token from the Relay team.


## Creating an App on fly.io

Creating a Relay Server on fly.io in only 3 commands...
```bash
flyctl launch \
  --no-deploy \
  --copy-config \
  --from https://github.com/no-instructions/relay-server-template \
  --config=fly.fs.toml
flyctl secrets set Y_SWEET_AUTH=<token from Relay team>
flyctl deploy
```

## Security

The default server configuration above involves sharing a private-key with the Relay control plane.
This allows the Relay control plane to issue tokens to users in order for them to access your Relay Server.
However, this mean that it is possible for the Relay control plane to issue a key and then connect to your documents.

To prevent this, we recommend that you configure your Relay Server so that it is not be accessible from the public internet.

We recommend using any of these providers:
 - Cloudflare Zero Trust
 - Tailscale tailnet
 - Fly.io wireguard private network (.flycast)

If you change the public facing URL, you will need to update the Y_SWEET_URL_PREFIX to your new url and notify us.

For instructions on how to configure a fly.io wireguard private network see [ADVANCED](ADVANCED.md).


## Advanced

For more advanced topics like S3 persistence and custom domains, see [ADVANCED](ADVANCED.md).

# Acknowledgements

The Relay Collaboration Server is a fork of [y-sweet](https://github.com/jamsocket/y-sweet) by the talented folks at jamsocket.com

y-sweet builds on [y-crdt](https://github.com/y-crdt/y-crdt) by Bartosz Sypytkowski, Kevin Jahns, and the y-crdt community.

The server source code is MIT licenced and available [here](https://github.com/no-instructions/y-sweet).
