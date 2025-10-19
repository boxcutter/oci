# ubuntu-autoinstall

This image can be used to generate Ubuntu custom autoinstall ISOs - standard Ubuntu boot images that have some additional text files providing answers to all installation prompts/inputs. This script is based
on [cloudymax/pxeless](https://github.com/cloudymax/pxeless) which is in
turn based on [covertsh/ubuntu-autoinstall-generator](https://github.com/covertsh/ubuntu-autoinstall-generator).

Creating a bootable ISO requires embedding special boot sectors on the image that require root permissions. It's easier to assemble a temporary filesystem with all the necessary permissions within a container image, and then discard it once the ISO has been created.

You'll need to create an [`autoinstall.yaml`](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html#interactive-sections)
file that contains your answers to all installation configuration prompts ahead of time. A good way to create a starter version of this file is to run through the Ubuntu install process manually on the desired equipment. The  Ubuntu installer will create an autoinstall for repeating the installation in `/var/log/installer/autoinstall-user-data`. You can use this file as a starting point, then edit the file as needed.

Once you have an autoinstall.yaml file, download the ubuntu install ISO you wish to customize, and run this script to copy the `autoinstall.yaml` file to the ISO and modify the boot config so the autoinstall will be run in zero touch mode.

## Autoinstall on the root of the installation media

By default, this script uses the `--config-root` mode for configuring the autoinstall. The `autoinstall.yaml` is copied to the root of the install media. This is the recommended way to create a zero-touch install for Ubuntu 24.04 (or higher):

### Ubuntu Desktop

```bash
$ curl -LO https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso
$ docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/ubuntu-autoinstall \
    --source ubuntu-24.04.3-desktop-amd64.iso \
    --autoinstall autoinstall.yaml \
    --config-root
```

### Ubuntu Server

```
$ https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso
$ docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/ubuntu-autoinstall \
    --source ubuntu-24.04.3-live-server-amd64.iso \
    --autoinstall autoinstall.yaml \
    --config-root
```

## Autoinstall by way of cloud-config



## CLI

```bash
% docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/ubuntu-autoinstall -h
Usage:  /app/image-create.sh [options]

Ubuntu Autoinstall ISO generator

  -h, --help                Print help
  -s, --source PATH         Source ISO path
  -d, --destination PATH    Destination ISO path
  -a, --autoinstall PATH    Autoinstall config file
  -g, --grub PATH           Grub.cfg file
  -l, --loopback PATH       Loopback.cfg file
  -m, --metadata PATH       meta-data config file
  -N, --config-nocloud      Copy autoinstall config as NoCloud provider
  -R, --config-root         Copy autoinstall to ISO root
```
