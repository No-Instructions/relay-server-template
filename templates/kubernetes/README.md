# Kubernetes with [Tigris](https://www.tigrisdata.com/docs/) storage + [Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault)

This uses `helm` to fill in the template files included.

You'll need to edit [`values.yaml`](values.yaml) and fill it in with appropriate values
for your deployment.

```bash
helm install relay-server deploy --namespace <your-namespace> --create-namespace
```

## Configuration

You'll need to edit [`values.yaml`](values.yaml) and fill it in with appropriate values:

### Variables
- `hostname`: Your custom domain
- `env.relayServerUrl`: URL for your service within your private network
- `env.relayServerStorage`: S3 storage URL (e.g., "s3://your-bucket-name/")
- `env.awsRegion`: AWS region (use "auto" for Tigris, R2)
- `env.awsEndpointUrlS3`: For S3-compatible services (Tigris, MinIO, R2, etc.)
- `env.awsS3UsePathStyle`: Set to "true" for path-style URLs if needed

## Secrets

This template uses Azure KeyVault for secrets. If you aren't using Azure, you'll need a
completely different way to inject these 2 environment variables securely, which will mean
modifying the chart [templates](templates) themselves.

For this to work with Azure without further customization, you'll need the name of the
KeyVault in `values.yaml`, and the KeyVault must contain the following named secrets:

``` text
relay-server-aws-access-key
relay-server-aws-secret-key
```

If you change the name of the Chart from `relay-server` to something else, you'll
need that same prefix on the above secret names
(`s/relay-server/your-chart-name/`).
