# doctl

The command line interface for the Digital Ocean API.

This image packages releases from https://github.com/digitalocean/doctl

# Using doctl

Set up some environment variables that are commonly used by other tools:

- DIGITALOCEAN_ACCESS_TOKEN
- DIGITALOCEAN_SSH_KEY_IDS
- DIGITALOCEAN_REGION

You can generate a new token via https://cloud.digitalocean.com/account/api/tokens

SSH_KEY_IDS is the Digital Ocean API numeric identifier for each ssh key, not the friendly string name. You can get the numeric identifier with the following API call. It's the `id` field:

```
curl -X GET https://api.digitalocean.com/v2/account/keys -H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN"
```

Many commands require user input, so it is recommend to pass the `--interactive` and `--tty` flags as well:

```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl account get
```

## Command-line interface examples

Listing public images
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute image list-distribution --public
```

Listing regions
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute region list
```

Listing image sizes/pricing
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute size list
```

Creating a Droplet
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=DIGITALOCEAN_SSH_KEY_IDS \
  --env=DIGITALOCEAN_REGION \
  docker.io/boxcutter/doctl compute droplet create ubuntu20-04 \
    --ssh-keys $DIGITALOCEAN_SSH_KEY_IDS \
    --size s-1vcpu-1gb \
    --image ubuntu-22-04-x64 \
    --region $DIGITALOCEAN_REGION \
    --enable-ipv6 \
    --enable-monitoring
```

SSH into a running instance
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --mount type=bind,source="$HOME/.ssh/id_ed25519",target="/root/.ssh/id_ed25519",readonly \
  docker.io/boxcutter/doctl compute ssh <DROPLET_ID>
```

Listing current droplets
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute droplet list
```

Deleting a Droplet
```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute droplet delete --force <DROPLET_ID>
```


# CLI

```
% docker container run --rm docker.io/boxcutter/doctl
doctl is a command line interface (CLI) for the DigitalOcean API.

Usage:
  doctl [command]

Available Commands:
  1-click         Display commands that pertain to 1-click applications
  account         Display commands that retrieve account details
  apps            Display commands for working with apps
  auth            Display commands for authenticating doctl with an account
  balance         Display commands for retrieving your account balance
  billing-history Display commands for retrieving your billing history
  completion      Generate the autocompletion script for the specified shell
  compute         Display commands that manage infrastructure
  databases       Display commands that manage databases
  help            Help about any command
  invoice         Display commands for retrieving invoices for your account
  kubernetes      Displays commands to manage Kubernetes clusters and configurations
  monitoring      [Beta] Display commands to manage monitoring
  projects        Manage projects and assign resources to them
  registry        Display commands for working with container registries
  serverless      Develop and test serverless functions
  version         Show the current version
  vpcs            Display commands that manage VPCs

Flags:
  -t, --access-token string   API V2 access token
  -u, --api-url string        Override default API endpoint
  -c, --config string         Specify a custom config file (default "/root/.config/doctl/config.yaml")
      --context string        Specify a custom authentication context name
  -h, --help                  help for doctl
  -o, --output string         Desired output format [text|json] (default "text")
      --trace                 Show a log of network activity while performing a command
  -v, --verbose               Enable verbose output

Use "doctl [command] --help" for more information about a command.
```
