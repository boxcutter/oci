alertmanager
------------
This image repackages alertmanager releaes from
https://github.com/prometheus/alertmanager/releases

This image is based on https://github.com/prometheus/alertmanager/blob/main/Dockerfile

Image Source: https://github.com/boxcutter/oci/tree/main/prometheus/alertmanager

CLI
---
```
% docker run -it --rm docker.io/boxcutter/alertmanager --help
usage: alertmanager [<flags>]

    Flags:
    -h, --help                     Show context-sensitive help (also try
    --help-long and --help-man).
    --config.file="alertmanager.yml"
    Alertmanager configuration file name.
    --storage.path="data/"     Base path for data storage.
    --data.retention=120h      How long to keep data for.
    --data.maintenance-interval=15m
    Interval between garbage collection and
    snapshotting to disk of the silences and the
    notification logs.
    --alerts.gc-interval=30m   Interval between alert GC.
    --web.systemd-socket       Use systemd socket activation listeners instead
    of port listeners (Linux only).
    --web.listen-address=:9093 ...
    Addresses on which to expose metrics and web
    interface. Repeatable for multiple addresses.
    --web.config.file=""       [EXPERIMENTAL] Path to configuration file that
    can enable TLS or authentication.
    --web.external-url=WEB.EXTERNAL-URL
    The URL under which Alertmanager is externally
    reachable (for example, if Alertmanager
    is served via a reverse proxy). Used for
    generating relative and absolute links back
    to Alertmanager itself. If the URL has a path
    portion, it will be used to prefix all HTTP
    endpoints served by Alertmanager. If omitted,
    relevant URL components will be derived
    automatically.
    --web.route-prefix=WEB.ROUTE-PREFIX
    Prefix for the internal routes of
    web endpoints. Defaults to path of
    --web.external-url.
    --web.get-concurrency=0    Maximum number of GET requests processed
    concurrently. If negative or zero, the limit is
    GOMAXPROC or 8, whichever is larger.
    --web.timeout=0            Timeout for HTTP requests. If negative or zero,
    no timeout is set.
    --cluster.listen-address="0.0.0.0:9094"
    Listen address for cluster. Set to empty string
    to disable HA mode.
    --cluster.advertise-address=CLUSTER.ADVERTISE-ADDRESS
    Explicit address to advertise in cluster.
    --cluster.peer=CLUSTER.PEER ...
    Initial peers (may be repeated).
    --cluster.peer-timeout=15s
    Time to wait between peers to send
    notifications.
    --cluster.gossip-interval=200ms
    Interval between sending gossip messages.
    By lowering this value (more frequent) gossip
    messages are propagated across the cluster more
    quickly at the expense of increased bandwidth.
    --cluster.pushpull-interval=1m0s
    Interval for gossip state syncs. Setting this
    interval lower (more frequent) will increase
    convergence speeds across larger clusters at
    the expense of increased bandwidth usage.
    --cluster.tcp-timeout=10s  Timeout for establishing a stream connection
    with a remote node for a full state sync,
    and for stream read and write operations.
    --cluster.probe-timeout=500ms
    Timeout to wait for an ack from a probed node
    before assuming it is unhealthy. This should be
    set to 99-percentile of RTT (round-trip time)
    on your network.
    --cluster.probe-interval=1s
    Interval between random node probes. Setting
    this lower (more frequent) will cause the
    cluster to detect failed nodes more quickly at
    the expense of increased bandwidth usage.
    --cluster.settle-timeout=1m0s
    Maximum time to wait for cluster connections to
    settle before evaluating notifications.
    --cluster.reconnect-interval=10s
    Interval between attempting to reconnect to
    lost peers.
    --cluster.reconnect-timeout=6h0m0s
    Length of time to attempt to reconnect to a
    lost peer.
    --cluster.tls-config=""    [EXPERIMENTAL] Path to config yaml file
    that can enable mutual TLS within the gossip
    protocol.
    --cluster.allow-insecure-public-advertise-address-discovery
    [EXPERIMENTAL] Allow alertmanager to discover
    and listen on a public IP address.
    --log.level=info           Only log messages with the given severity or
    above. One of: [debug, info, warn, error]
    --log.format=logfmt        Output format of log messages. One of: [logfmt,
    json]
    --version                  Show application version.
```
