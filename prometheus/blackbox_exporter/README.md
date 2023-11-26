blackbox_exporter
-----------------
This image repackages blackbox_exporter releases from
https://github.com/prometheus/blackbox_exporter/releases

This image is based on https://github.com/prometheus/blackbox_exporter/blob/master/Dockerfile

Image Source: https://github.com/boxcutter/oci/tree/main/prometheus/blackbox_exporter

CLI
---
```
% docker run -it --rm docker.io/boxcutter/blackbox_exporter --help
usage: blackbox_exporter [<flags>]

    Flags:
    -h, --help                     Show context-sensitive help (also try --help-long and --help-man).
    --config.file="blackbox.yml"
    Blackbox exporter configuration file.
    --timeout-offset=0.5       Offset to subtract from timeout in seconds.
    --config.check             If true validate the config file and then exit.
    --history.limit=100        The maximum amount of items to keep in the history.
    --web.external-url=<url>   The URL under which Blackbox exporter is externally reachable (for example, if Blackbox exporter is served via a reverse proxy). Used for generating relative and absolute links back to Blackbox exporter itself. If the URL has a path portion, it will be used to prefix all HTTP endpoints served by Blackbox exporter. If omitted, relevant URL components will be derived automatically.
        --web.route-prefix=<path>  Prefix for the internal routes of web endpoints. Defaults to path of --web.external-url.
            --web.systemd-socket       Use systemd socket activation listeners instead of port listeners (Linux only).
            --web.listen-address=:9115 ...
            Addresses on which to expose metrics and web interface. Repeatable for multiple addresses.
            --web.config.file=""       [EXPERIMENTAL] Path to configuration file that can enable TLS or authentication.
            --log.level=info           Only log messages with the given severity or above. One of: [debug, info, warn, error]
            --log.format=logfmt        Output format of log messages. One of: [logfmt, json]
            --version                  Show application version.
            ```