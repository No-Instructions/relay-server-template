## Advanced Usage

### Persisting to S3

Our goal for this section is to set up all of the secrets that are required to run the Relay Server.

First, we need to launch our app with the S3 config.
```
fly launch --copy-config --no-deloy --config=fly.s3.toml
```

Next, we need an S3 bucket and credentials to access that bucket. You can find your own way here, but I recommend using `s3-credentials`.

```
pip install s3-credentials
```

Now run `s3-credentials` and capture the output. We'll immediately send this to fly.io encrypted secret storage.
```
S3_CREDS=$(s3-credentials create-bucket "relay-${APP_NAME}" --region us-west-2)

ACCESS_KEY=$(echo "$S3_CREDS" | python3 -c "import sys, json; print(json.load(sys.stdin)['AccessKeyId'])")
SECRET_KEY=$(echo "$S3_CREDS" | python3 -c "import sys, json; print(json.load(sys.stdin)['SecretAccessKey'])")
REGION=$(echo "$S3_CREDS" | python3 -c "import sys, json; print(json.load(sys.stdin)['Region'])")
BUCKET=$(echo "$S3_CREDS" | python3 -c "import sys, json; print(json.load(sys.stdin)['Bucket'])")

flyctl secrets set \
    AWS_ACCESS_KEY_ID="$ACCESS_KEY" \
    AWS_SECRET_ACCESS_KEY="$SECRET_KEY" \
    AWS_REGION="$REGION" \
    STORAGE_BUCKET="$BUCKET"
    Y_SWEET_STORE="s3://$BUCKET/"
```

### Generating your own Private Key

You will need to send us the API key to allow the Relay service to create and authorize documents on your server.

Generating an API key
```
docker run --rm -it docker.system3.md/relay-server y-sweet gen-auth --json
KEYS= docker run --rm -it docker.system3.md/relay-server y-sweet gen-auth --json
PRIVATE_KEY= echo $KEYS | python3 -c "import sys; import json; print(json.load(sys.stdin)['private_key'])"
API_KEY= echo $KEYS | python3 -c "import sys; import json; print(json.load(sys.stdin)['server_token'])"
flyctl secrets set \
    Y_SWEET_AUTH="$PRIVATE_KEY" \
```

Next we need to send a connection string to the Relay team.
You can print your connection string like this:
```
echo "https://${API_KEY}@${APP_NAME}.fly.dev"
```

Contact us via email (daniel@system3.md) or on [Discord](https://discord.system3.md) for instructions on how to send us this key securely.


### Using a custom domain

You can use `flyctl certs` to add a custom domain to your app.
Update the Y_SWEET_URL_PREFIX in your service and in the connection string that you provide us.


### Using the flycast private network
#### Release your public IPs
```
fly ips list -c myfly.toml 
# VERSION	IP                    	TYPE              	REGION	CREATED AT       
# v6     	<your public ipv6>    	public (dedicated)	global	28m36s ago      	
# v4     	<your public ipv4>    	public (shared)   	      	Jan 1 0001 00:00

fly ips release <your public ipv6>
fly ips release <your public ipv4>
```

#### Deploy with a flycast ip
```
fly secrets set Y_SWEET_URL_PREFIX=http://$APP_NAME.flycast:8080
fly deploy --flycast
```

#### Create a wireguard connection
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

#### Let us know!
We will update the connection string that users will receive and will connect to.
