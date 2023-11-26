node_exporter
-------------
This image repackages Prometheus node_exporter releases from
https://github.com/prometheus/node_exporter/releases

The image is based on
https://github.com/prometheus/node_exporter/blob/master/Dockerfile

Image source: https://github.com/polymathrobotics/oci/tree/main/prometheus/node_exporter

For more information on using node_exporter, refer to https://prometheus.io/docs/guides/node-exporter/

Using node_exporter
-------------------
The `node_exporter` listens on HTTP port 9100 by default. See the `--help`
output for more options.

The `node_exporter` is designed to monitor the host system of a Linux
operating system setup. node_exporter requires access to the `/proc`
and `/sys` filesystems on the host. You'll need to provide extra parameters
to ensure that information is scraped from the host instead of within
the container environment.

```
docker container run -it --rm \
  --name node_exporter \
  --network host \
  --pid host \
  --cap-add=SYS_TIME \
  --mount type=bind,source=/,target=/host/root,readonly \
  --mount type=bind,source=/sys,target=/host/sys,readonly \
  --mount type=bind,source=/proc,target=/host/proc,readonly \
  docker.io/polymathrobotics/node_exporter \
    --path.rootfs=/host
```

CLI
---
```
% docker container run -it --rm docker.io/polymathrobotics/node_exporter --help
usage: node_exporter [<flags>]

  Flags:
  -h, --help                     Show context-sensitive help (also try --help-long and --help-man).
  --collector.arp.device-include=COLLECTOR.ARP.DEVICE-INCLUDE
  Regexp of arp devices to include (mutually exclusive to device-exclude).
  --collector.arp.device-exclude=COLLECTOR.ARP.DEVICE-EXCLUDE
  Regexp of arp devices to exclude (mutually exclusive to device-include).
  --collector.bcache.priorityStats
  Expose expensive priority stats.
  --collector.cpu.guest      Enables metric node_cpu_guest_seconds_total
  --collector.cpu.info       Enables metric cpu_info
  --collector.cpu.info.flags-include=COLLECTOR.CPU.INFO.FLAGS-INCLUDE
  Filter the `flags` field in cpuInfo with a value that must be a regular expression
  --collector.cpu.info.bugs-include=COLLECTOR.CPU.INFO.BUGS-INCLUDE
  Filter the `bugs` field in cpuInfo with a value that must be a regular expression
  --collector.diskstats.device-exclude="^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$"
  Regexp of diskstats devices to exclude (mutually exclusive to device-include).
  --collector.diskstats.device-include=COLLECTOR.DISKSTATS.DEVICE-INCLUDE
  Regexp of diskstats devices to include (mutually exclusive to device-exclude).
  --collector.ethtool.device-include=COLLECTOR.ETHTOOL.DEVICE-INCLUDE
  Regexp of ethtool devices to include (mutually exclusive to device-exclude).
  --collector.ethtool.device-exclude=COLLECTOR.ETHTOOL.DEVICE-EXCLUDE
  Regexp of ethtool devices to exclude (mutually exclusive to device-include).
  --collector.ethtool.metrics-include=".*"
  Regexp of ethtool stats to include.
  --collector.filesystem.mount-points-exclude="^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+|var/lib/containers/storage/.+)($|/)"
  Regexp of mount points to exclude for filesystem collector.
  --collector.filesystem.fs-types-exclude="^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
  Regexp of filesystem types to exclude for filesystem collector.
  --collector.ipvs.backend-labels="local_address,local_port,remote_address,remote_port,proto,local_mark"
  Comma separated list for IPVS backend stats labels.
  --collector.netclass.ignored-devices="^$"
  Regexp of net devices to ignore for netclass collector.
  --collector.netclass.ignore-invalid-speed
  Ignore devices where the speed is invalid. This will be the default behavior in 2.x.
  --collector.netclass.netlink
  Use netlink to gather stats instead of /proc/net/dev.
  --collector.netclass_rtnl.with-stats
  Expose the statistics for each network device, replacing netdev collector.
  --collector.netdev.device-include=COLLECTOR.NETDEV.DEVICE-INCLUDE
  Regexp of net devices to include (mutually exclusive to device-exclude).
  --collector.netdev.device-exclude=COLLECTOR.NETDEV.DEVICE-EXCLUDE
  Regexp of net devices to exclude (mutually exclusive to device-include).
  --collector.netdev.address-info
  Collect address-info for every device
  --collector.netdev.enable-detailed-metrics
  Use (incompatible) metric names that provide more detailed stats on Linux
  --collector.netdev.netlink
  Use netlink to gather stats instead of /proc/net/dev.
  --collector.netstat.fields="^(.*_(InErrors|InErrs)|Ip_Forwarding|Ip(6|Ext)_(InOctets|OutOctets)|Icmp6?_(InMsgs|OutMsgs)|TcpExt_(Listen.*|Syncookies.*|TCPSynRetrans|TCPTimeouts)|Tcp_(ActiveOpens|InSegs|OutSegs|OutRsts|PassiveOpens|RetransSegs|CurrEstab)|Udp6?_(InDatagrams|OutDatagrams|NoPorts|RcvbufErrors|SndbufErrors))$"
  Regexp of fields to return for netstat collector.
  --collector.ntp.server="127.0.0.1"
  NTP server to use for ntp collector
  --collector.ntp.server-port=123
  UDP port number to connect to on NTP server
  --collector.ntp.protocol-version=4
  NTP protocol version
  --collector.ntp.server-is-local
  Certify that collector.ntp.server address is not a public ntp server
  --collector.ntp.ip-ttl=1   IP TTL to use while sending NTP query
  --collector.ntp.max-distance=3.46608s
  Max accumulated distance to the root
  --collector.ntp.local-offset-tolerance=1ms
  Offset between local clock and local ntpd time to tolerate
  --path.procfs="/proc"      procfs mountpoint.
  --path.sysfs="/sys"        sysfs mountpoint.
  --path.rootfs="/"          rootfs mountpoint.
  --path.udev.data="/run/udev/data"
  udev data path.
  --collector.perf.cpus=""   List of CPUs from which perf metrics should be collected
  --collector.perf.tracepoint=COLLECTOR.PERF.TRACEPOINT ...
  perf tracepoint that should be collected
  --collector.powersupply.ignored-supplies="^$"
  Regexp of power supplies to ignore for powersupplyclass collector.
  --collector.qdisc.fixtures=""
  test fixtures to use for qdisc collector end-to-end testing
  --collector.qdisk.device-include=COLLECTOR.QDISK.DEVICE-INCLUDE
  Regexp of qdisk devices to include (mutually exclusive to device-exclude).
  --collector.qdisk.device-exclude=COLLECTOR.QDISK.DEVICE-EXCLUDE
  Regexp of qdisk devices to exclude (mutually exclusive to device-include).
  --collector.rapl.enable-zone-label
  Enables service unit metric unit_start_time_seconds
  --collector.runit.servicedir="/etc/service"
  Path to runit service directory.
  --collector.stat.softirq   Export softirq calls per vector
  --collector.supervisord.url="http://localhost:9001/RPC2"
  XML RPC endpoint.
  --collector.sysctl.include=COLLECTOR.SYSCTL.INCLUDE ...
  Select sysctl metrics to include
  --collector.sysctl.include-info=COLLECTOR.SYSCTL.INCLUDE-INFO ...
  Select sysctl metrics to include as info metrics
  --collector.systemd.unit-include=".+"
  Regexp of systemd units to include. Units must both match include and not match exclude to be included.
  --collector.systemd.unit-exclude=".+\\.(automount|device|mount|scope|slice)"
  Regexp of systemd units to exclude. Units must both match include and not match exclude to be included.
  --collector.systemd.enable-task-metrics
  Enables service unit tasks metrics unit_tasks_current and unit_tasks_max
  --collector.systemd.enable-restarts-metrics
  Enables service unit metric service_restart_total
  --collector.systemd.enable-start-time-metrics
  Enables service unit metric unit_start_time_seconds
  --collector.tapestats.ignored-devices="^$"
  Regexp of devices to ignore for tapestats.
  --collector.textfile.directory=""
  Directory to read text files with metrics from.
  --collector.vmstat.fields="^(oom_kill|pgpg|pswp|pg.*fault).*"
  Regexp of fields to return for vmstat collector.
  --collector.wifi.fixtures=""
  test fixtures to use for wifi collector metrics
  --collector.arp            Enable the arp collector (default: enabled).
  --collector.bcache         Enable the bcache collector (default: enabled).
  --collector.bonding        Enable the bonding collector (default: enabled).
  --collector.btrfs          Enable the btrfs collector (default: enabled).
  --collector.buddyinfo      Enable the buddyinfo collector (default: disabled).
  --collector.cgroups        Enable the cgroups collector (default: disabled).
  --collector.conntrack      Enable the conntrack collector (default: enabled).
  --collector.cpu            Enable the cpu collector (default: enabled).
  --collector.cpufreq        Enable the cpufreq collector (default: enabled).
  --collector.diskstats      Enable the diskstats collector (default: enabled).
  --collector.dmi            Enable the dmi collector (default: enabled).
  --collector.drbd           Enable the drbd collector (default: disabled).
  --collector.drm            Enable the drm collector (default: disabled).
  --collector.edac           Enable the edac collector (default: enabled).
  --collector.entropy        Enable the entropy collector (default: enabled).
  --collector.ethtool        Enable the ethtool collector (default: disabled).
  --collector.fibrechannel   Enable the fibrechannel collector (default: enabled).
  --collector.filefd         Enable the filefd collector (default: enabled).
  --collector.filesystem     Enable the filesystem collector (default: enabled).
  --collector.hwmon          Enable the hwmon collector (default: enabled).
  --collector.infiniband     Enable the infiniband collector (default: enabled).
  --collector.interrupts     Enable the interrupts collector (default: disabled).
  --collector.ipvs           Enable the ipvs collector (default: enabled).
  --collector.ksmd           Enable the ksmd collector (default: disabled).
  --collector.lnstat         Enable the lnstat collector (default: disabled).
  --collector.loadavg        Enable the loadavg collector (default: enabled).
  --collector.logind         Enable the logind collector (default: disabled).
  --collector.mdadm          Enable the mdadm collector (default: enabled).
  --collector.meminfo        Enable the meminfo collector (default: enabled).
  --collector.meminfo_numa   Enable the meminfo_numa collector (default: disabled).
  --collector.mountstats     Enable the mountstats collector (default: disabled).
  --collector.netclass       Enable the netclass collector (default: enabled).
  --collector.netdev         Enable the netdev collector (default: enabled).
  --collector.netstat        Enable the netstat collector (default: enabled).
  --collector.network_route  Enable the network_route collector (default: disabled).
  --collector.nfs            Enable the nfs collector (default: enabled).
  --collector.nfsd           Enable the nfsd collector (default: enabled).
  --collector.ntp            Enable the ntp collector (default: disabled).
  --collector.nvme           Enable the nvme collector (default: enabled).
  --collector.os             Enable the os collector (default: enabled).
  --collector.perf           Enable the perf collector (default: disabled).
  --collector.powersupplyclass
  Enable the powersupplyclass collector (default: enabled).
  --collector.pressure       Enable the pressure collector (default: enabled).
  --collector.processes      Enable the processes collector (default: disabled).
  --collector.qdisc          Enable the qdisc collector (default: disabled).
  --collector.rapl           Enable the rapl collector (default: enabled).
  --collector.runit          Enable the runit collector (default: disabled).
  --collector.schedstat      Enable the schedstat collector (default: enabled).
  --collector.selinux        Enable the selinux collector (default: enabled).
  --collector.slabinfo       Enable the slabinfo collector (default: disabled).
  --collector.sockstat       Enable the sockstat collector (default: enabled).
  --collector.softnet        Enable the softnet collector (default: enabled).
  --collector.stat           Enable the stat collector (default: enabled).
  --collector.supervisord    Enable the supervisord collector (default: disabled).
  --collector.sysctl         Enable the sysctl collector (default: disabled).
  --collector.systemd        Enable the systemd collector (default: disabled).
  --collector.tapestats      Enable the tapestats collector (default: enabled).
  --collector.tcpstat        Enable the tcpstat collector (default: disabled).
  --collector.textfile       Enable the textfile collector (default: enabled).
  --collector.thermal_zone   Enable the thermal_zone collector (default: enabled).
  --collector.time           Enable the time collector (default: enabled).
  --collector.timex          Enable the timex collector (default: enabled).
  --collector.udp_queues     Enable the udp_queues collector (default: enabled).
  --collector.uname          Enable the uname collector (default: enabled).
  --collector.vmstat         Enable the vmstat collector (default: enabled).
  --collector.wifi           Enable the wifi collector (default: disabled).
  --collector.xfs            Enable the xfs collector (default: enabled).
  --collector.zfs            Enable the zfs collector (default: enabled).
  --collector.zoneinfo       Enable the zoneinfo collector (default: disabled).
  --web.telemetry-path="/metrics"
  Path under which to expose metrics.
  --web.disable-exporter-metrics
  Exclude metrics about the exporter itself (promhttp_*, process_*, go_*).
  --web.max-requests=40      Maximum number of parallel scrape requests. Use 0 to disable.
  --collector.disable-defaults
  Set all collectors to disabled by default.
  --runtime.gomaxprocs=1     The target number of CPUs Go will run on (GOMAXPROCS)
  --web.systemd-socket       Use systemd socket activation listeners instead of port listeners (Linux only).
  --web.listen-address=:9100 ...
  Addresses on which to expose metrics and web interface. Repeatable for multiple addresses.
  --web.config.file=""       [EXPERIMENTAL] Path to configuration file that can enable TLS or authentication.
  --log.level=info           Only log messages with the given severity or above. One of: [debug, info, warn, error]
  --log.format=logfmt        Output format of log messages. One of: [logfmt, json]
  --version                  Show application version.
```
