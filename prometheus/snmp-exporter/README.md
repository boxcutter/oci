snmp_exporter
-----------------
This image repackages snmp_exporter releases from
https://github.com/prometheus/snmp_exporter/releases

This image is based on https://github.com/prometheus/snmp_exporter/blob/main/Dockerfile

Image Source: https://github.com/boxcutter/oci/tree/main/prometheus/snmp_exporter

CLI
---
```
% docker run -it --rm docker.io/boxcutter/snmp-exporter --help
usage: snmp_exporter [<flags>]


Flags:
  -h, --[no-]help                Show context-sensitive help (also try
                                 --help-long and --help-man).
      --[no-]snmp.wrap-large-counters
                                 Wrap 64-bit counters to avoid floating point
                                 rounding.
      --snmp.source-address=""   Source address to send snmp from in the format
                                 'address:port' to use when connecting targets.
                                 If the port parameter is empty or '0', as in
                                 '127.0.0.1:' or '[::1]:0', a source port number
                                 is automatically (random) chosen.
      --config.file=snmp.yml ...
                                 Path to configuration file.
      --[no-]dry-run             Only verify configuration is valid and exit.
      --snmp.module-concurrency=1
                                 The number of modules to fetch concurrently per
                                 scrape
      --[no-]snmp.debug-packets  Include a full debug trace of SNMP packet
                                 traffics.
      --[no-]config.expand-environment-variables
                                 Expand environment variables to source secrets
      --web.telemetry-path="/metrics"
                                 Path under which to expose metrics.
      --[no-]web.systemd-socket  Use systemd socket activation listeners instead
                                 of port listeners (Linux only).
      --web.listen-address=:9116 ...
                                 Addresses on which to expose metrics and web
                                 interface. Repeatable for multiple addresses.
                                 Examples: `:9100` or `[::1]:9100` for http,
                                 `vsock://:9100` for vsock
      --web.config.file=""       Path to configuration file that can
                                 enable TLS or authentication. See:
                                 https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md
      --log.level=info           Only log messages with the given severity or
                                 above. One of: [debug, info, warn, error]
      --log.format=logfmt        Output format of log messages. One of: [logfmt,
                                 json]
      --[no-]version             Show application version.
```
