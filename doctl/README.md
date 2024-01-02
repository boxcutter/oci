#  doctl

The command line interface for the Digital Ocean API.

This image packages releases from https://github.com/digitalocean/doctl

Source location: https://github.com/boxcutter/oci/tree/main/doctl

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

Some commands require user input, for those to pass the `--interactive` and `--tty` flags as well:

```
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl account get
```

NOTE: Don't use the `tty` flag when you plan to pipe the output of docker to another program. It adds
extra newlines to the output: https://github.com/moby/moby/issues/8513

## Command-line interface examples

Listing public images
```
% docker container run --rm \
    --env=DIGITALOCEAN_ACCESS_TOKEN \
    docker.io/boxcutter/doctl compute image list-distribution --public
ID           Name                  Type        Distribution    Slug                   Public    Min Disk
106433672    7 x64                 snapshot    CentOS          centos-7-x64           true      9
106434191    8 Stream x64          snapshot    CentOS          centos-stream-8-x64    true      10
106557160    11 x64                snapshot    Debian          debian-11-x64          true      7
106569146    10 x64                snapshot    Debian          debian-10-x64          true      7
108962679    RockyLinux 8.4 x64    snapshot    Rocky Linux     rockylinux-8-4-x64     true      10
112929454    20.04 (LTS) x64       snapshot    Ubuntu          ubuntu-20-04-x64       true      7
112929540    18.04 (LTS) x64       snapshot    Ubuntu          ubuntu-18-04-x64       true      7
114476748    RockyLinux 8.6 x64    snapshot    Rocky Linux     rockylinux-8-x64       true      10
114545510    RockyLinux 8.5 x64    snapshot    Rocky Linux     rockylinux-8-5-x64     true      10
116738240    RockyLinux 9.0 x64    snapshot    Rocky Linux     rockylinux-9-x64       true      10
117732073    9 Stream x64          snapshot    CentOS          centos-stream-9-x64    true      10
118326629    36 x64                snapshot    Fedora          fedora-36-x64          true      15
119383150    22.10 x64             snapshot    Ubuntu          ubuntu-22-10-x64       true      7
119703569    AlmaLinux 9           snapshot    AlmaLinux       almalinux-9-x64        true      10
119703732    AlmaLinux 8           snapshot    AlmaLinux       almalinux-8-x64        true      10
121028718    37 x64                snapshot    Fedora          fedora-37-x64          true      15
129211873    22.04 (LTS) x64       snapshot    Ubuntu          ubuntu-22-04-x64       true      7
```

Listing regions
```
% docker container run --rm \
    --env=DIGITALOCEAN_ACCESS_TOKEN \
    docker.io/boxcutter/doctl compute region list
Slug    Name               Available
nyc1    New York 1         true
sfo1    San Francisco 1    false
nyc2    New York 2         false
ams2    Amsterdam 2        false
sgp1    Singapore 1        true
lon1    London 1           true
nyc3    New York 3         true
ams3    Amsterdam 3        true
fra1    Frankfurt 1        true
tor1    Toronto 1          true
sfo2    San Francisco 2    false
blr1    Bangalore 1        true
sfo3    San Francisco 3    true
syd1    Sydney 1           true
```

Listing image sizes/pricing
```
% docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute size list
Slug                    Description                   Memory    VCPUs    Disk    Price Monthly    Price Hourly
s-1vcpu-512mb-10gb      Basic                         512       1        10      4.00             0.005950
s-1vcpu-1gb             Basic                         1024      1        25      6.00             0.008930
s-1vcpu-1gb-amd         Basic AMD                     1024      1        25      7.00             0.010420
s-1vcpu-1gb-intel       Basic Intel                   1024      1        25      7.00             0.010420
s-1vcpu-2gb             Basic                         2048      1        50      12.00            0.017860
s-1vcpu-2gb-amd         Basic AMD                     2048      1        50      14.00            0.020830
s-1vcpu-2gb-intel       Basic Intel                   2048      1        50      14.00            0.020830
s-2vcpu-2gb             Basic                         2048      2        60      18.00            0.026790
s-2vcpu-2gb-amd         Basic AMD                     2048      2        60      21.00            0.031250
s-2vcpu-2gb-intel       Basic Intel                   2048      2        60      21.00            0.031250
s-2vcpu-4gb             Basic                         4096      2        80      24.00            0.035710
s-2vcpu-4gb-amd         Basic AMD                     4096      2        80      28.00            0.041670
s-2vcpu-4gb-intel       Basic Intel                   4096      2        80      28.00            0.041670
c-2                     CPU-Optimized                 4096      2        25      42.00            0.062500
c2-2vcpu-4gb            CPU-Optimized 2x SSD          4096      2        50      47.00            0.069940
s-4vcpu-8gb             Basic                         8192      4        160     48.00            0.071430
s-4vcpu-8gb-amd         Basic AMD                     8192      4        160     56.00            0.083330
s-4vcpu-8gb-intel       Basic Intel                   8192      4        160     56.00            0.083330
g-2vcpu-8gb             General Purpose               8192      2        25      63.00            0.093750
gd-2vcpu-8gb            General Purpose 2x SSD        8192      2        50      68.00            0.101190
m-2vcpu-16gb            Memory-Optimized              16384     2        50      84.00            0.125000
c-4                     CPU-Optimized                 8192      4        50      84.00            0.125000
c2-4vcpu-8gb            CPU-Optimized 2x SSD          8192      4        100     94.00            0.139880
s-8vcpu-16gb            Basic                         16384     8        320     96.00            0.142860
m3-2vcpu-16gb           Memory-Optimized 3x SSD       16384     2        150     104.00           0.154760
c-4-intel               Premium Intel                 8192      4        50      109.00           0.162200
s-8vcpu-16gb-amd        Basic AMD                     16384     8        320     112.00           0.166670
s-8vcpu-16gb-intel      Basic Intel                   16384     8        320     112.00           0.166670
c2-4vcpu-8gb-intel      Premium Intel                 8192      4        100     122.00           0.181550
g-4vcpu-16gb            General Purpose               16384     4        50      126.00           0.187500
so-2vcpu-16gb           Storage-Optimized             16384     2        300     131.00           0.194940
m6-2vcpu-16gb           Memory-Optimized 6x SSD       16384     2        300     131.00           0.194940
gd-4vcpu-16gb           General Purpose 2x SSD        16384     4        100     136.00           0.202380
so1_5-2vcpu-16gb        Storage-Optimized 1.5x SSD    16384     2        450     163.00           0.242560
m-4vcpu-32gb            Memory-Optimized              32768     4        100     168.00           0.250000
c-8                     CPU-Optimized                 16384     8        100     168.00           0.250000
c2-8vcpu-16gb           CPU-Optimized 2x SSD          16384     8        200     188.00           0.279760
m3-4vcpu-32gb           Memory-Optimized 3x SSD       32768     4        300     208.00           0.309520
c-8-intel               Premium Intel                 16384     8        100     218.00           0.324400
c2-8vcpu-16gb-intel     Premium Intel                 16384     8        200     244.00           0.363100
g-8vcpu-32gb            General Purpose               32768     8        100     252.00           0.375000
so-4vcpu-32gb           Storage-Optimized             32768     4        600     262.00           0.389880
m6-4vcpu-32gb           Memory-Optimized 6x SSD       32768     4        600     262.00           0.389880
gd-8vcpu-32gb           General Purpose 2x SSD        32768     8        200     272.00           0.404760
so1_5-4vcpu-32gb        Storage-Optimized 1.5x SSD    32768     4        900     326.00           0.485120
m-8vcpu-64gb            Memory-Optimized              65536     8        200     336.00           0.500000
c-16                    CPU-Optimized                 32768     16       200     336.00           0.500000
c2-16vcpu-32gb          CPU-Optimized 2x SSD          32768     16       400     376.00           0.559520
m3-8vcpu-64gb           Memory-Optimized 3x SSD       65536     8        600     416.00           0.619050
c-16-intel              Premium Intel                 32768     16       200     437.00           0.650300
c2-16vcpu-32gb-intel    Premium Intel                 32768     16       400     489.00           0.727680
g-16vcpu-64gb           General Purpose               65536     16       200     504.00           0.750000
so-8vcpu-64gb           Storage-Optimized             65536     8        1200    524.00           0.779760
m6-8vcpu-64gb           Memory-Optimized 6x SSD       65536     8        1200    524.00           0.779760
gd-16vcpu-64gb          General Purpose 2x SSD        65536     16       400     544.00           0.809520
so1_5-8vcpu-64gb        Storage-Optimized 1.5x SSD    65536     8        1800    652.00           0.970240
m-16vcpu-128gb          Memory-Optimized              131072    16       400     672.00           1.000000
c-32                    CPU-Optimized                 65536     32       400     672.00           1.000000
c2-32vcpu-64gb          CPU-Optimized 2x SSD          65536     32       800     752.00           1.119050
m3-16vcpu-128gb         Memory-Optimized 3x SSD       131072    16       1200    832.00           1.238100
c-32-intel              Premium Intel                 65536     32       400     874.00           1.300600
c2-32vcpu-64gb-intel    Premium Intel                 65536     32       800     978.00           1.455360
c-48                    CPU-Optimized                 98304     48       600     1008.00          1.500000
m-24vcpu-192gb          Memory-Optimized              196608    24       600     1008.00          1.500000
g-32vcpu-128gb          General Purpose               131072    32       400     1008.00          1.500000
so-16vcpu-128gb         Storage-Optimized             131072    16       2400    1048.00          1.559520
m6-16vcpu-128gb         Memory-Optimized 6x SSD       131072    16       2400    1048.00          1.559520
gd-32vcpu-128gb         General Purpose 2x SSD        131072    32       800     1088.00          1.619050
c2-48vcpu-96gb          CPU-Optimized 2x SSD          98304     48       1200    1128.00          1.678570
m3-24vcpu-192gb         Memory-Optimized 3x SSD       196608    24       1800    1248.00          1.857140
g-40vcpu-160gb          General Purpose               163840    40       500     1260.00          1.875000
so1_5-16vcpu-128gb      Storage-Optimized 1.5x SSD    131072    16       3600    1304.00          1.940480
c-48-intel              Premium Intel                 98304     48       600     1310.00          1.949400
m-32vcpu-256gb          Memory-Optimized              262144    32       800     1344.00          2.000000
gd-40vcpu-160gb         General Purpose 2x SSD        163840    40       1000    1360.00          2.023810
c2-48vcpu-96gb-intel    Premium Intel                 98304     48       1200    1466.00          2.181550
so-24vcpu-192gb         Storage-Optimized             196608    24       3600    1572.00          2.339290
m6-24vcpu-192gb         Memory-Optimized 6x SSD       196608    24       3600    1572.00          2.339290
m3-32vcpu-256gb         Memory-Optimized 3x SSD       262144    32       2400    1664.00          2.476190
so1_5-24vcpu-192gb      Storage-Optimized 1.5x SSD    196608    24       5400    1956.00          2.910710
so-32vcpu-256gb         Storage-Optimized             262144    32       4800    2096.00          3.119050
m6-32vcpu-256gb         Memory-Optimized 6x SSD       262144    32       4800    2096.00          3.119050
so1_5-32vcpu-256gb      Storage-Optimized 1.5x SSD    262144    32       7200    2608.00          3.880950
```

Creating a Droplet
```
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=DIGITALOCEAN_SSH_KEY_IDS \
  --env=DIGITALOCEAN_REGION \
  docker.io/boxcutter/doctl compute droplet create ubuntu22-04 \
    --ssh-keys $DIGITALOCEAN_SSH_KEY_IDS \
    --size s-1vcpu-1gb \
    --image ubuntu-22-04-x64 \
    --region $DIGITALOCEAN_REGION \
    --enable-ipv6 \
    --enable-monitoring
```

Listing current droplets
```
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl compute droplet list
```

SSH into a running instance

You can use two methods:
1. Mounting the private key in the container (simpler to use)
2. Using SSH forwarding

It is recommended that you use the ssh-agent and use SSH forwarding as it is
slightly more secure.

Mounting private key in the container
```
# Mounting private key into container
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --mount type=bind,source="$HOME/.ssh/id_ed25519",target="/root/.ssh/id_ed25519",readonly \
  docker.io/boxcutter/doctl compute ssh <DROPLET_ID>
```

Using SSH forwarding to get the private key into the container environment
```
# Using SSH forwarding
ssh-add -l # Check if keys are cached
ssh-add # If not add identities
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=SSH_AUTH_SOCK \
  --mount type=bind,source=$SSH_AUTH_SOCK,target=$SSH_AUTH_SOCK,readonly \
  docker.io/boxcutter/doctl compute ssh <DROPLET_ID>

# Using SSH forwarding with Docker Desktop for Mac
# Seems like you need to use a magic path to forward SSH_AUTH_SOCK into the VM running the Linux instancea
ssh-add -l # Check if keys are cached
ssh-add # If not add identities
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock \
  --mount type=bind,source=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock,readonly \
  docker.io/boxcutter/doctl compute ssh <DROPLET_ID>  
```

Deleting a Droplet
```
docker container run --rm \
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
  serverless      Develop, test, and deploy serverless functions
  version         Show the current version
  vpcs            Display commands that manage VPCs

Flags:
  -t, --access-token string   API V2 access token
  -u, --api-url string        Override default API endpoint
  -c, --config string         Specify a custom config file (default "/root/.config/doctl/config.yaml")
      --context string        Specify a custom authentication context name
  -h, --help                  help for doctl
      --interactive           Enable interactive behavior. Defaults to true if the terminal supports it (default false)
  -o, --output string         Desired output format [text|json] (default "text")
      --trace                 Show a log of network activity while performing a command
  -v, --verbose               Enable verbose output

  Use "doctl [command] --help" for more information about a command.
```
