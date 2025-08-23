# doctl

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

```bash
curl -X GET https://api.digitalocean.com/v2/account/keys \
  -H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN"
```

Some commands require user input, for those to pass the `--interactive` and `--tty` flags as well:

```bash
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl account get
```

NOTE: Don't use the `tty` flag when you plan to pipe the output of docker to another program. It adds
extra newlines to the output: https://github.com/moby/moby/issues/8513

## Command-line interface examples

Listing public images
```bash
% docker container run --rm \
    --env=DIGITALOCEAN_ACCESS_TOKEN \
    docker.io/boxcutter/doctl doctl compute image list-distribution --public
ID           Name                              Type    Distribution    Slug                   Public    Min Disk    Created
135509519    9 x64                             base    Rocky Linux     rockylinux-9-x64       true      10          2023-06-28T21:06:21Z
143033891    8 x64                             base    Rocky Linux     rockylinux-8-x64       true      10          2023-10-25T11:45:21Z
159651797    22.04 (LTS) x64                   base    Ubuntu          ubuntu-22-04-x64       true      7           2024-07-02T16:43:14Z
168639140    12 x64                            base    Debian          debian-12-x64          true      7           2024-10-24T21:24:54Z
169810124    41 x64                            base    Fedora          fedora-41-x64          true      15          2024-11-07T21:03:46Z
189723042    AMD AI/ML Ready                   base    Ubuntu          gpu-amd-base           true      30          2025-06-09T21:24:11Z
191457505    NVIDIA AI/ML Ready                base    Ubuntu          gpu-h100x1-base        true      30          2025-06-26T17:14:44Z
191457541    NVIDIA AI/ML Ready with NVLink    base    Ubuntu          gpu-h100x8-base        true      30          2025-06-26T17:19:10Z
193655201    42 x64                            base    Fedora          fedora-42-x64          true      15          2025-07-17T17:34:59Z
194271330    25.04 x64                         base    Ubuntu          ubuntu-25-04-x64       true      7           2025-07-23T15:30:12Z
195932981    24.04 (LTS) x64                   base    Ubuntu          ubuntu-24-04-x64       true      7           2025-08-08T15:11:27Z
196174368    AlmaLinux 9                       base    AlmaLinux       almalinux-9-x64        true      10          2025-08-10T20:00:17Z
196493389    AlmaLinux 8                       base    AlmaLinux       almalinux-8-x64        true      10          2025-08-13T21:35:16Z
197014428    AlmaLinux 10                      base    AlmaLinux       almalinux-10-x64       true      10          2025-08-18T16:34:37Z
197131532    9 Stream x64                      base    CentOS          centos-stream-9-x64    true      10          2025-08-19T23:52:30Z
197216326    10 x64                            base    Rocky Linux     rockylinux-10-x64      true      10          2025-08-20T18:03:04Z
```

Listing regions
```bash
% docker container run --rm \
    --env=DIGITALOCEAN_ACCESS_TOKEN \
    docker.io/boxcutter/doctl doctl compute region list
Slug    Name               Available
nyc1    New York 1         true
sfo1    San Francisco 1    false
nyc2    New York 2         true
ams2    Amsterdam 2        false
sgp1    Singapore 1        true
lon1    London 1           true
nyc3    New York 3         true
ams3    Amsterdam 3        true
fra1    Frankfurt 1        true
tor1    Toronto 1          true
sfo2    San Francisco 2    true
blr1    Bangalore 1        true
sfo3    San Francisco 3    true
syd1    Sydney 1           true
atl1    Atlanta 1          true
```

Listing image sizes/pricing
```bash
% docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl doctl compute size list
Slug                        Description                               Memory     VCPUs    Disk    Price Monthly    Price Hourly
s-1vcpu-512mb-10gb          Basic                                     512        1        10      4.00             0.005950
s-1vcpu-1gb                 Basic                                     1024       1        25      6.00             0.008930
s-1vcpu-1gb-amd             Basic AMD                                 1024       1        25      7.00             0.010420
s-1vcpu-1gb-intel           Basic Intel                               1024       1        25      7.00             0.010420
s-1vcpu-1gb-35gb-intel      Basic Intel                               1024       1        35      8.00             0.011900
s-1vcpu-2gb                 Basic                                     2048       1        50      12.00            0.017860
s-1vcpu-2gb-amd             Basic AMD                                 2048       1        50      14.00            0.020830
s-1vcpu-2gb-intel           Basic Intel                               2048       1        50      14.00            0.020830
s-1vcpu-2gb-70gb-intel      Basic Intel                               2048       1        70      16.00            0.023810
s-2vcpu-2gb                 Basic                                     2048       2        60      18.00            0.026790
s-2vcpu-2gb-amd             Basic AMD                                 2048       2        60      21.00            0.031250
s-2vcpu-2gb-intel           Basic Intel                               2048       2        60      21.00            0.031250
s-2vcpu-2gb-90gb-intel      Basic Intel                               2048       2        90      24.00            0.035710
s-2vcpu-4gb                 Basic                                     4096       2        80      24.00            0.035710
s-2vcpu-4gb-amd             Basic AMD                                 4096       2        80      28.00            0.041670
s-2vcpu-4gb-intel           Basic Intel                               4096       2        80      28.00            0.041670
s-2vcpu-4gb-120gb-intel     Basic Intel                               4096       2        120     32.00            0.047620
s-2vcpu-8gb-amd             Basic AMD                                 8192       2        100     42.00            0.062500
c-2                         CPU-Optimized                             4096       2        25      42.00            0.062500
c2-2vcpu-4gb                CPU-Optimized 2x SSD                      4096       2        50      47.00            0.069940
s-2vcpu-8gb-160gb-intel     Basic Intel                               8192       2        160     48.00            0.071430
s-4vcpu-8gb                 Basic                                     8192       4        160     48.00            0.071430
s-4vcpu-8gb-amd             Basic AMD                                 8192       4        160     56.00            0.083330
s-4vcpu-8gb-intel           Basic Intel                               8192       4        160     56.00            0.083330
g-2vcpu-8gb                 General Purpose                           8192       2        25      63.00            0.093750
s-4vcpu-8gb-240gb-intel     Basic Intel                               8192       4        240     64.00            0.095240
gd-2vcpu-8gb                General Purpose 2x SSD                    8192       2        50      68.00            0.101190
g-2vcpu-8gb-intel           General Purpose — Premium Intel           8192       2        30      76.00            0.113100
gd-2vcpu-8gb-intel          General Purpose — Premium Intel 2x SSD    8192       2        60      79.00            0.117560
s-4vcpu-16gb-amd            Basic AMD                                 16384      4        200     84.00            0.125000
m-2vcpu-16gb                Memory-Optimized                          16384      2        50      84.00            0.125000
c-4                         CPU-Optimized                             8192       4        50      84.00            0.125000
c2-4vcpu-8gb                CPU-Optimized 2x SSD                      8192       4        100     94.00            0.139880
s-4vcpu-16gb-320gb-intel    Basic Intel                               16384      4        320     96.00            0.142860
s-8vcpu-16gb                Basic                                     16384      8        320     96.00            0.142860
m-2vcpu-16gb-intel          Premium Memory-Optimized                  16384      2        50      99.00            0.147320
m3-2vcpu-16gb               Memory-Optimized 3x SSD                   16384      2        150     104.00           0.154760
c-4-intel                   Premium Intel                             8192       4        50      109.00           0.162200
m3-2vcpu-16gb-intel         Premium Memory-Optimized 3x SSD           16384      2        150     110.00           0.163690
s-8vcpu-16gb-amd            Basic AMD                                 16384      8        320     112.00           0.166670
s-8vcpu-16gb-intel          Basic Intel                               16384      8        320     112.00           0.166670
c2-4vcpu-8gb-intel          Premium Intel                             8192       4        100     122.00           0.181550
g-4vcpu-16gb                General Purpose                           16384      4        50      126.00           0.187500
s-8vcpu-16gb-480gb-intel    Basic Intel                               16384      8        480     128.00           0.190480
so-2vcpu-16gb-intel         Premium Storage-Optimized                 16384      2        300     131.00           0.194940
so-2vcpu-16gb               Storage-Optimized                         16384      2        300     131.00           0.194940
m6-2vcpu-16gb               Memory-Optimized 6x SSD                   16384      2        300     131.00           0.194940
gd-4vcpu-16gb               General Purpose 2x SSD                    16384      4        100     136.00           0.202380
so1_5-2vcpu-16gb-intel      Premium Storage-Optimized 1.5x SSD        16384      2        450     139.00           0.206850
g-4vcpu-16gb-intel          General Purpose — Premium Intel           16384      4        60      151.00           0.224700
gd-4vcpu-16gb-intel         General Purpose — Premium Intel 2x SSD    16384      4        120     158.00           0.235120
so1_5-2vcpu-16gb            Storage-Optimized 1.5x SSD                16384      2        450     163.00           0.242560
s-8vcpu-32gb-amd            Basic AMD                                 32768      8        400     168.00           0.250000
m-4vcpu-32gb                Memory-Optimized                          32768      4        100     168.00           0.250000
c-8                         CPU-Optimized                             16384      8        100     168.00           0.250000
c2-8vcpu-16gb               CPU-Optimized 2x SSD                      16384      8        200     188.00           0.279760
s-8vcpu-32gb-640gb-intel    Basic Intel                               32768      8        640     192.00           0.285710
m-4vcpu-32gb-intel          Premium Memory-Optimized                  32768      4        100     198.00           0.294640
m3-4vcpu-32gb               Memory-Optimized 3x SSD                   32768      4        300     208.00           0.309520
c-8-intel                   Premium Intel                             16384      8        100     218.00           0.324400
m3-4vcpu-32gb-intel         Premium Memory-Optimized 3x SSD           32768      4        300     220.00           0.327380
c2-8vcpu-16gb-intel         Premium Intel                             16384      8        200     244.00           0.363100
g-8vcpu-32gb                General Purpose                           32768      8        100     252.00           0.375000
so-4vcpu-32gb-intel         Premium Storage-Optimized                 32768      4        600     262.00           0.389880
so-4vcpu-32gb               Storage-Optimized                         32768      4        600     262.00           0.389880
m6-4vcpu-32gb               Memory-Optimized 6x SSD                   32768      4        600     262.00           0.389880
gd-8vcpu-32gb               General Purpose 2x SSD                    32768      8        200     272.00           0.404760
so1_5-4vcpu-32gb-intel      Premium Storage-Optimized 1.5x SSD        32768      4        900     278.00           0.413690
g-8vcpu-32gb-intel          General Purpose — Premium Intel           32768      8        120     302.00           0.449400
gd-8vcpu-32gb-intel         General Purpose — Premium Intel 2x SSD    32768      8        240     317.00           0.471730
so1_5-4vcpu-32gb            Storage-Optimized 1.5x SSD                32768      4        900     326.00           0.485120
m-8vcpu-64gb                Memory-Optimized                          65536      8        200     336.00           0.500000
c-16                        CPU-Optimized                             32768      16       200     336.00           0.500000
c2-16vcpu-32gb              CPU-Optimized 2x SSD                      32768      16       400     376.00           0.559520
m-8vcpu-64gb-intel          Premium Memory-Optimized                  65536      8        200     396.00           0.589290
m3-8vcpu-64gb               Memory-Optimized 3x SSD                   65536      8        600     416.00           0.619050
c-16-intel                  Premium Intel                             32768      16       200     437.00           0.650300
m3-8vcpu-64gb-intel         Premium Memory-Optimized 3x SSD           65536      8        600     440.00           0.654760
c2-16vcpu-32gb-intel        Premium Intel                             32768      16       400     489.00           0.727680
g-16vcpu-64gb               General Purpose                           65536      16       200     504.00           0.750000
so-8vcpu-64gb-intel         Premium Storage-Optimized                 65536      8        1200    524.00           0.779760
so-8vcpu-64gb               Storage-Optimized                         65536      8        1200    524.00           0.779760
m6-8vcpu-64gb               Memory-Optimized 6x SSD                   65536      8        1200    524.00           0.779760
gd-16vcpu-64gb              General Purpose 2x SSD                    65536      16       400     544.00           0.809520
so1_5-8vcpu-64gb-intel      Premium Storage-Optimized 1.5x SSD        65536      8        1800    556.00           0.827380
gpu-4000adax1-20gb          RTX 4000 Ada GPU Droplet - 1X             32768      8        500     565.44           0.760000
g-16vcpu-64gb-intel         General Purpose — Premium Intel           65536      16       240     605.00           0.900300
gd-16vcpu-64gb-intel        General Purpose — Premium Intel 2x SSD    65536      16       480     634.00           0.943450
so1_5-8vcpu-64gb            Storage-Optimized 1.5x SSD                65536      8        1800    652.00           0.970240
m-16vcpu-128gb              Memory-Optimized                          131072     16       400     672.00           1.000000
c-32                        CPU-Optimized                             65536      32       400     672.00           1.000000
c2-32vcpu-64gb              CPU-Optimized 2x SSD                      65536      32       800     752.00           1.119050
m-16vcpu-128gb-intel        Premium Memory-Optimized                  131072     16       400     792.00           1.178570
m3-16vcpu-128gb             Memory-Optimized 3x SSD                   131072     16       1200    832.00           1.238100
c-32-intel                  Premium Intel                             65536      32       400     874.00           1.300600
m3-16vcpu-128gb-intel       Premium Memory-Optimized 3x SSD           131072     16       1200    880.00           1.309520
c2-32vcpu-64gb-intel        Premium Intel                             65536      32       800     978.00           1.455360
c-48                        CPU-Optimized                             98304      48       600     1008.00          1.500000
m-24vcpu-192gb              Memory-Optimized                          196608     24       600     1008.00          1.500000
g-32vcpu-128gb              General Purpose                           131072     32       400     1008.00          1.500000
so-16vcpu-128gb-intel       Premium Storage-Optimized                 131072     16       2400    1048.00          1.559520
so-16vcpu-128gb             Storage-Optimized                         131072     16       2400    1048.00          1.559520
m6-16vcpu-128gb             Memory-Optimized 6x SSD                   131072     16       2400    1048.00          1.559520
gd-32vcpu-128gb             General Purpose 2x SSD                    131072     32       800     1088.00          1.619050
so1_5-16vcpu-128gb-intel    Premium Storage-Optimized 1.5x SSD        131072     16       3600    1112.00          1.654760
c2-48vcpu-96gb              CPU-Optimized 2x SSD                      98304      48       1200    1128.00          1.678570
gpu-l40sx1-48gb             L40S GPU Droplet - 1X                     65536      8        500     1168.08          1.570000
gpu-6000adax1-48gb          RTX 6000 Ada GPU Droplet - 1X             65536      8        500     1168.08          1.570000
m-24vcpu-192gb-intel        Premium Memory-Optimized                  196608     24       600     1188.00          1.767860
g-32vcpu-128gb-intel        General Purpose — Premium Intel           131072     32       480     1210.00          1.800600
m3-24vcpu-192gb             Memory-Optimized 3x SSD                   196608     24       1800    1248.00          1.857140
g-40vcpu-160gb              General Purpose                           163840     40       500     1260.00          1.875000
gd-32vcpu-128gb-intel       General Purpose — Premium Intel 2x SSD    131072     32       960     1268.00          1.886900
so1_5-16vcpu-128gb          Storage-Optimized 1.5x SSD                131072     16       3600    1304.00          1.940480
c-48-intel                  Premium Intel                             98304      48       600     1310.00          1.949400
m3-24vcpu-192gb-intel       Premium Memory-Optimized 3x SSD           196608     24       1800    1320.00          1.964290
m-32vcpu-256gb              Memory-Optimized                          262144     32       800     1344.00          2.000000
gd-40vcpu-160gb             General Purpose 2x SSD                    163840     40       1000    1360.00          2.023810
c2-48vcpu-96gb-intel        Premium Intel                             98304      48       1200    1466.00          2.181550
gpu-mi300x1-192gb           AMD MI300X - 1X                           245760     20       720     1480.56          1.990000
so-24vcpu-192gb-intel       Premium Storage-Optimized                 196608     24       3600    1572.00          2.339290
so-24vcpu-192gb             Storage-Optimized                         196608     24       3600    1572.00          2.339290
m6-24vcpu-192gb             Memory-Optimized 6x SSD                   196608     24       3600    1572.00          2.339290
m-32vcpu-256gb-intel        Premium Memory-Optimized                  262144     32       800     1584.00          2.357140
c-60-intel                  Premium Intel                             122880     60       750     1639.00          2.438990
m3-32vcpu-256gb             Memory-Optimized 3x SSD                   262144     32       2400    1664.00          2.476190
so1_5-24vcpu-192gb-intel    Premium Storage-Optimized 1.5x SSD        196608     24       5400    1668.00          2.482140
m3-32vcpu-256gb-intel       Premium Memory-Optimized 3x SSD           262144     32       2400    1760.00          2.619050
g-48vcpu-192gb-intel        General Purpose — Premium Intel           196608     48       720     1814.00          2.699400
c2-60vcpu-120gb-intel       Premium Intel                             122880     60       1500    1834.00          2.729170
gd-48vcpu-192gb-intel       General Purpose — Premium Intel 2x SSD    196608     48       1440    1901.00          2.828870
so1_5-24vcpu-192gb          Storage-Optimized 1.5x SSD                196608     24       5400    1956.00          2.910710
so-32vcpu-256gb-intel       Premium Storage-Optimized                 262144     32       4800    2096.00          3.119050
so-32vcpu-256gb             Storage-Optimized                         262144     32       4800    2096.00          3.119050
m6-32vcpu-256gb             Memory-Optimized 6x SSD                   262144     32       4800    2096.00          3.119050
so1_5-32vcpu-256gb-intel    Premium Storage-Optimized 1.5x SSD        262144     32       7200    2224.00          3.309520
g-60vcpu-240gb-intel        General Purpose — Premium Intel           245760     60       900     2269.00          3.376490
m-48vcpu-384gb-intel        Premium Memory-Optimized                  393216     48       1200    2376.00          3.535710
gd-60vcpu-240gb-intel       General Purpose — Premium Intel 2x SSD    245760     60       1800    2378.00          3.538690
gpu-h100x1-80gb             H100 GPU - 1X                             245760     20       720     2522.16          3.390000
gpu-h200x1-141gb            Nvidia H200 - 1X                          245760     24       720     2559.36          3.440000
so1_5-32vcpu-256gb          Storage-Optimized 1.5x SSD                262144     32       7200    2608.00          3.880950
m3-48vcpu-384gb-intel       Premium Memory-Optimized 3x SSD           393216     48       3600    2640.00          3.928570
so-48vcpu-384gb-intel       Premium Storage-Optimized                 393216     48       7000    3144.00          4.678570
gpu-mi300x8-1536gb          AMD MI300X - 8X                           1966080    160      2046    11844.48         15.920000
gpu-h100x8-640gb            H100 GPU - 8X                             1966080    160      2046    17796.48         23.920000
gpu-h200x8-1128gb           Nvidia H200 - 8X                          1966080    192      2046    20474.88         27.520000
```

Creating a Droplet
```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=DIGITALOCEAN_SSH_KEY_IDS \
  --env=DIGITALOCEAN_REGION \
  docker.io/boxcutter/doctl doctl compute droplet create ubuntu22-04 \
    --ssh-keys $DIGITALOCEAN_SSH_KEY_IDS \
    --size s-1vcpu-1gb \
    --image ubuntu-24-04-x64 \
    --region $DIGITALOCEAN_REGION \
    --enable-ipv6 \
    --enable-monitoring
```

Listing current droplets
```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl doctl compute droplet list
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
  docker.io/boxcutter/doctl doctl compute ssh <DROPLET_ID>
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
  docker.io/boxcutter/doctl doctl compute ssh <DROPLET_ID>

# Using SSH forwarding with Docker Desktop for Mac
# Seems like you need to use a magic path to forward SSH_AUTH_SOCK into the VM running the Linux instancea
ssh-add -l # Check if keys are cached
ssh-add # If not add identities
docker container run --rm --interactive --tty \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock \
  --mount type=bind,source=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock,readonly \
  docker.io/boxcutter/doctl doctl compute ssh <DROPLET_ID>  
```

Deleting a Droplet
```
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl doctl compute droplet delete --force <DROPLET_ID>
```

Creating a Kubernetes Cluster

```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --env=DIGITALOCEAN_REGION \
  docker.io/boxcutter/doctl doctl kubernetes cluster create first-cluster \
    --region $DIGITALOCEAN_REGION \
    --size s-1vcpu-2gb-intel \
    --count 1
```

List droplets compatible with Kubernetes clusters

```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  docker.io/boxcutter/doctl doctl kubernetes options sizes
```

To manage the cluster

```
# Writes/merges kubeconfig into ~/.kube/config
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --mount type=bind,source=$HOME/.kube,target=/home/doctl/.kube \
  docker.io/boxcutter/doctl doctl kubernetes cluster kubeconfig save first-cluster


docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --mount type=bind,source=$HOME/.kube,target=/home/doctl/.kube \
  docker.io/boxcutter/doctl kubectl get nodes
```

Listing current Kubernetes Clusters

```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
    docker.io/boxcutter/doctl doctl kubernetes cluster list
```

Deleting Kubernetes cluster

```bash
docker container run --rm \
  --env=DIGITALOCEAN_ACCESS_TOKEN \
  --mount type=bind,source=$HOME/.kube,target=/home/doctl/.kube \
  docker.io/boxcutter/doctl doctl kubernetes cluster delete <NAME|ID> --force
```

# CLI

```bash
% docker container run --rm docker.io/boxcutter/doctl
doctl is a command line interface (CLI) for the DigitalOcean API.

Usage:
  doctl [command]

Manage DigitalOcean Resources:
  1-click         Display commands that pertain to 1-click applications
  account         Display commands that retrieve account details
  apps            Displays commands for working with apps
  compute         Display commands that manage infrastructure
  databases       Display commands that manage databases
  genai           Manage GenAI resources
  kubernetes      Displays commands to manage Kubernetes clusters and configurations
  monitoring      Display commands to manage monitoring
  network         Display commands that manage network products
  projects        Manage projects and assign resources to them
  registry        Display commands for working with container registries
  serverless      Develop, test, and deploy serverless functions
  spaces          Display commands that manage DigitalOcean Spaces.
  vpcs            Display commands that manage VPCs

Configure doctl:
  auth            Display commands for authenticating doctl with an account
  version         Show the current version

View Billing:
  balance         Display commands for retrieving your account balance
  billing-history Display commands for retrieving your billing history
  invoice         Display commands for retrieving invoices for your account

Additional Commands:
  completion      Generate the autocompletion script for the specified shell
  help            Help about any command

Flags:
  -t, --access-token string   API V2 access token
  -u, --api-url string        Override default API endpoint
  -c, --config string         Specify a custom config file (default "/root/.config/doctl/config.yaml")
      --context string        Specify a custom authentication context name
  -h, --help                  help for doctl
      --http-retry-max int    Set maximum number of retries for requests that fail with a 429 or 500-level error (default 5)
      --interactive           Enable interactive behavior. Defaults to true if the terminal supports it (default false)
  -o, --output string         Desired output format [text|json] (default "text")
      --trace                 Show a log of network activity while performing a command
  -v, --verbose               Enable verbose output

Use "doctl [command] --help" for more information about a command.
```
