# Kubernetes with [Tigris](https://www.tigrisdata.com/docs/) storage + [Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault)

This uses `helm` to fill in the template files included.

You'll need to edit [`values.yaml`](values.yaml) and fill it in with appropriate values
for your deployment.

```bash
helm install obsidian-relay-server deploy --namespace <your-namespace> --create-namespace
```

## Secrets

This template uses Azure KeyVault for secrets. If you aren't using Azure, you'll need a
completely different way to inject these 3 environment variables securely, which will mean
modifying the chart [templates](templates) themselves.

For this to work with Azure without further customization, you'll need the name of the
KeyVault in `values.yaml`, and the KeyVault must contain the following named secrets:

``` text
obsidian-relay-server-auth-key
obsidian-relay-server-aws-access-key
obsidian-relay-server-aws-secret-key
```

If you change the name of the Chart from `obsidian-relay-server` to something else, you'll
need that same prefix on the above secret names
(`s/obsidian-relay-server/your-chart-name/`).
