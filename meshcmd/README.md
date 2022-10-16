# meshcmd

Command line tool used to perform many tasks related to computer management of Intel Active Management Technology (AMT) devices.

This image packages releases from https://github.com/Ylianst/MeshCentral/tree/master/agents

Image source: https://github.com/boxcutter/oci/tree/main/meshcmd

## Background

An Intel employee working on the Intel AMT team, [Ylian Saint-Hilaire](https://www.linkedin.com/in/ylianst/), created a more platform-agnostic set of tools for managing Intel AMT machines, written in Node.js called MeshCentral: [https://meshcentral.com/info/](https://meshcentral.com/info/)

While written with more modern tooling, MeshCentral’s approach to remote management is still a little too Windows-centric and doesn’t allow 100% automated management through APIs. We don’t use it for very much. It is intended to be set up and used like a Microsoft SMS server. A good example of this is [https://www.sprinxle.com/](https://www.sprinxle.com/)

However, MeshCommander includes a wonderful little tool called MeshCommander includes a great standalone tool that can be used to work with Intel AMT through the command line and access the remote desktop in a web browser via WebRTC, which is very useful. We’ve packaged MeshCommander as the container image `boxcutter/meshcmd`.

## Using meshcmd

The most useful cli command is the AmtPower command which can be used locally or remotely:

```
% docker run -it --rm \
    docker.io/boxcutter/meshcmd help AmtPower
AmtPower will get current pwoer state or send a reboot command to a remote Intel AMT device. Example usage:

  meshcmd amtpower --reset --host 1.2.3.4 --user admin --pass mypassword --tls

Required arguments:

  --host [hostname]      The IP address or DNS name of Intel AMT.
  --pass [password]      The Intel AMT login password.

Optional arguments:

  --reset, --poweron, --poweroff, --powercycle, --sleep, --hibernate
  --user [username]                                    The Intel AMT login username, admin is default.
  --tls                                                Specifies that TLS must be used.
  --bootdevice [pxe|hdd|cd|ider-floppy|ider-cdrom]     Specifies the boot device to use after reset, poweron or powercycle.
  --bootindex [number]                                 Specifies the index of boot device to use.
```

And then you can also access nearly all Intel AMT functionality through a web-based GUI with MeshCommander. You can access the web GUI via http://localhost:3000 and configure connections to multiple machines:

```
% docker run -it --rm \
    -p 3000:3000 \
    docker.io/boxcutter/meshcmd MeshCommander
```

## CLI

```
% docker run -it --rm \
  polymathrobotics/meshcmd

MeshCentral Command (MeshCmd)  v1.0.80
No action specified, use MeshCmd like this:

  meshcmd [action] [arguments...]

Valid MeshCentral actions:
  Route             - Map a local TCP port to a remote computer.
  AmtConfig         - Setup Intel AMT on this computer.

Valid local actions:
  SMBios            - Display System Management BIOS tables for this computer.
  RawSMBios         - Display RAW System Management BIOS tables for this computer.
  MicroLMS          - Run MicroLMS, allowing local access to Intel AMT.
  AmtInfo           - Show Intel AMT version and activation state.
  AmtVersions       - Show all Intel ME version information.
  AmtHashes         - Show all Intel AMT trusted activation hashes.
  AmtCCM            - Activate Intel AMT into Client Control Mode.
  AmtDeactivate     - Deactivate Intel AMT if activated in Client Control mode.
  AmtAcmDeactivate  - Deactivate Intel AMT if activated in Admin Control mode.

Valid local or remote actions:
  MeshCommander     - Launch a local MeshCommander web server.
  AmtUUID           - Show Intel AMT unique identifier.
  AmtEventLog       - Show the Intel AMT event log.
  AmtAuditLog       - Show the Intel AMT audit log.
  AmtSaveState      - Save all Intel AMT WSMAN object to file.
  AmtPresence       - Heartbeat a local Intel AMT watchdog agent.
  AmtPower          - Perform remote Intel AMT power operation.
  AmtIDER           - Mount local disk image to remote computer.
  AmtFeatures       - Intel AMT features & user consent.
  AmtNetwork        - Intel AMT network interface settings.
  AmtScan           - Search local network for Intel AMT devices.
  AmtWifi           - Intel AMT Wifi interface settings.
  AmtWake           - Intel AMT Wake Alarms.
  AmtRPE            - Intel AMT Remote Platform Erase.
  AmtDDNS           - Intel AMT DDNS settings.
  AmtTerm           - Intel AMT Serial-over-LAN terminal.

Help on a specific action using:

  meshcmd help [action]
```
