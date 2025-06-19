# snmp-generator

This image packages the SNMP Exporter Config Generator tool from https://github.com/prometheus/snmp_exporter/tree/main/generator
It runs `/usr/bin/generator` by default.

All the default MIBs produced by the `make mibs` command are available
in the `/opt/snmp_exporter/generator/mibs` directory.

Peplink SNMP MIBs are available in the following directories:
- `/opt/snmp_exporter/generator/peplink/peplink`
- `/opt/snmp_exporter/generator/peplink/pepwave`
- `/opt/snmp_exporter/generator/peplink/pepxim`

To generate an `snmp.yml` for the Prometheus SNMP exporter, pass in the
directors of mibs, a path to a `generator.yml` file and the path to the
output `snmp.yml`:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/code \
  docker.io/boxcutter/snmp-generator \
    -m /opt/snmp_exporter/generator/mibs \
    -m /opt/snmp_exporter/generator/peplink/peplink \
    -g generator.yml \
    -o snmp.yml
```

For more information on the `generator.yml` file format, refer to
https://github.com/prometheus/snmp_exporter/blob/main/generator/FORMAT.md

## CLI

```bash
% docker run -it --rm docker.io/boxcutter/snmp-generator -h
usage: generator [<flags>] <command> [<args> ...]


Flags:
  -h, --[no-]help          Show context-sensitive help (also try --help-long and
                           --help-man).
      --[no-]fail-on-parse-errors
                           Exit with a non-zero status if there are MIB parsing
                           errors
      --snmp.mibopts="eu"  Toggle various defaults controlling MIB parsing,
                           see snmpwalk --help
  -m, --mibs-dir= ...      Paths to mibs directory
      --log.level=info     Only log messages with the given severity or above.
                           One of: [debug, info, warn, error]
      --log.format=logfmt  Output format of log messages. One of: [logfmt, json]

Commands:
help [<command>...]
    Show help.

generate [<flags>]
    Generate snmp.yml from generator.yml

parse_errors
    Debug: Print the parse errors output by NetSNMP

dump
    Debug: Dump the parsed and prepared MIBs
```
