#!/bin/bash

set -eu
set -o pipefail

# Ensure environment variables have defaults while allowing overrides
: "${DEBUG:=0}"
: "${SOURCE_ISO:=ubuntu-24.04.5-live-server-amd64.iso}"
: "${DESTINATION_ISO:=ubuntu-autoinstall.iso}"

: "${DEBUG:=0}"

debug() {
  if [ "$DEBUG" -eq 1 ]; then
    echo "DEBUG: $*" >&2
  fi
}


AUTOINSTALL_CONFIG_FILE="autoinstall.example"
GRUB_CONFIG_FILE=""
LOOPBACK_CONFIG_FILE=""
METADATA_CONFIG_FILE=""
CONFIG_MODE="nocloud"

ISO_FILESYSTEM_DIR=""
BOOT_IMAGE_DIR=""
TODAY=$(date +"%Y-%m-%d")
MBR_IMAGE=""
EFI_IMAGE=""

error() {
  echo "ERROR $*" >&2
}

die() {
  error "$@"
  exit 1
}

usage() {
  cat <<EOF
Usage:  $0 [options]

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
EOF
}

cleanup() {
  set +e
  [[ -n "${ISO_FILESYSTEM_DIR}" && -d "${ISO_FILESYSTEM_DIR}" ]] && rm -rf "${ISO_FILESYSTEM_DIR}"
  [[ -n "${BOOT_IMAGE_DIR}" && -d "${BOOT_IMAGE_DIR}" ]] && rm -rf "${BOOT_IMAGE_DIR}"
}
trap cleanup EXIT

args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -s|--source) SOURCE_ISO="${2-}"; shift ;;
      -d|--destination) DESTINATION_ISO="${2-}"; shift ;;
      -a|--autoinstall) AUTOINSTALL_CONFIG_FILE="${2-}"; shift ;;
      -g|--grub) GRUB_CONFIG_FILE="${2-}"; shift ;;
      -l|--loopback) LOOPBACK_CONFIG_FILE="${2-}"; shift ;;
      -m|--metadata) METADATA_CONFIG_FILE="${2-}"; shift ;;
      -N|--config-nocloud) CONFIG_MODE="nocloud" ;;
      -R|--config-root) CONFIG_MODE="root" ;;
      --) shift; break ;;
      -*) die "Unknown option: $1" ;;
      *)  break ;;
    esac
    shift
  done

  [[ -f "${SOURCE_ISO}" ]] || die "Source ISO not found: ${SOURCE_ISO}"
  [[ -f "${AUTOINSTALL_CONFIG_FILE}" ]] || die "Autoinstall config not found: ${AUTOINSTALL_CONFIG_FILE}"

  if [[ "${CONFIG_MODE}" == "nocloud" && -n "${METADATA_CONFIG_FILE}" && ! -f "${METADATA_CONFIG_FILE}" ]]; then
    die "Specified meta-data file not found: ${METADATA_CONFIG_FILE}"
  fi
}

create_tmp_dirs() {
  ISO_FILESYSTEM_DIR="$(mktemp -d)" || die "Could not create temporary ISO filesystem directory"
  BOOT_IMAGE_DIR="$(mktemp -d)" || die "Could not create temporary boot image directory"
  debug "Temp dirs: ISO_FILESYSTEM_DIR=${ISO_FILESYSTEM_DIR}, BOOT_IMAGE_DIR=${BOOT_IMAGE_DIR}"
}

extract_iso() {
  echo "Extracting ISO image -> ${SOURCE_ISO}..."

  # -osirrox on - enable "ISO Readback ROckRidge eXtractor" so it is possible
  #               to read/extract files out of an ISO into a local directory.
  # -indev "${ISO} - specifies the input image
  # -extract SOURCE TARGET - extract directory from ISO into target.
  xorriso -osirrox on -indev "${SOURCE_ISO}" -extract / "${ISO_FILESYSTEM_DIR}"

  # Ubuntu's installation ISOs are hybrid boot images, they contain a bootable
  # MBR (for BIOS boot) and a GPT header (for UEFI boot).
  MBR_IMAGE="ubuntu-original-${TODAY}.mbr"
  EFI_IMAGE="ubuntu-original-${TODAY}.efi"

  # The Master Boot Record (MBR) is standardized and always 512 bytes total:
  # | Offset (bytes) | Length (bytes) | Purpose                               |
  # |----------------|----------------|----------------------------------------|
  # | 0 – 445        | 446            | Bootloader code (executable boot stub) |
  # | 446 – 509      | 64             | Partition table (4 × 16-byte entries)  |
  # | 510 – 511      | 2              | Boot signature (0x55AA)                |

  # Only copy the bootloader code from the master boot record, not the
  # partition table or checksum
  dd if="${SOURCE_ISO}" bs=1 count=446 of="${BOOT_IMAGE_DIR}/${MBR_IMAGE}" status=none

  # Example fdisk output for a hybrid ISO (which supports BIOS and UEFI boot):
  # Device      Boot Start     End Sectors  Size Id Type
  # ubuntu.iso1 *       0  767999  768000  375M  0  Empty
  # ubuntu.iso2      768000  774143    6144    3M ef EFI (FAT-12/16/32)

  # Extract the appended EFI (GPT) image from the Ubuntu hybrid ISO. The UEFI
  # boot partition is tacked onto the end of the ISO filesystem.
  local START_BLOCK SECTORS
  START_BLOCK=$(fdisk -l "${SOURCE_ISO}" | awk '/\.iso2 /{print $2}')
  SECTORS=$(fdisk -l "${SOURCE_ISO}" | awk '/\.iso2 /{print $4}')
  [[ -n "${START_BLOCK}" && -n "${SECTORS}" ]] || die "Unable to locate appended EFI image in source ISO"
  dd if="${SOURCE_ISO}" bs=512 skip="${START_BLOCK}" count="${SECTORS}" of="${BOOT_IMAGE_DIR}/${EFI_IMAGE}" status=none
}

# Ensure "autoinstall" appears on linux lines and optionally add/remove NoCloud arg.
patch_grub_file() {
  local file="$1"
  [[ -f "${file}" ]] || return 0

  # The Ubuntu installer contains a safeguard intneded to prevent USB flash
  # drives with an autoinstall.yaml file from wiping out the wrong system.
  # By default, the Ubuntu installer will prompt for confirmation before
  # for installing. To bypass this prompt, you must add the argument
  # 'autoinstall' on the kernel command line

  # 1) Ensure 'autoinstall' is present before the trailing '---' on linux
  #    lines to make zero-touch deployments
  if ! grep -qE '^\s*linux .*autoinstall' "${file}"; then
    sed -i -E '
      /^[[:space:]]*linux(efi)?[[:space:]]/ {
        /[[:space:]]autoinstall([[:space:]]|$)/ b     # skip if already has autoinstall
        /[[:space:]]---/ s/[[:space:]]+---/ autoinstall ---/
        t
        s/$/ autoinstall/
      }
    ' "${file}"
  fi

  if [[ "${CONFIG_MODE}" == "nocloud" ]]; then
    # 2a) Add NoCloud datasource arg if missing
    if ! grep -q 'ds=nocloud\\;s=/cdrom/nocloud/' "${file}"; then
      sed -i -E '/^[[:space:]]*linux / s/ ---/ ds=nocloud\\;s=\/cdrom\/nocloud\/ ---/' "${file}"
    fi
  else
    # 2b) Remove any accidental NoCloud arg when in root mode
    sed -i -E 's/\s*ds=nocloud\\;s=\/cdrom\/nocloud\/\s*//g' "${file}"
  fi

  cat "${file}"
}

configure_autoinstall() {
  # Use custom GRUB files if provided, else patch existing ones
  if [[ -n "${GRUB_CONFIG_FILE}" ]]; then
    echo "Using custom grub.cfg: ${GRUB_CONFIG_FILE}"
    cp -f "${GRUB_CONFIG_FILE}" "${ISO_FILESYSTEM_DIR}/boot/grub/grub.cfg"
  else
    echo "Patching existing grub.cfg"
    patch_grub_file "${ISO_FILESYSTEM_DIR}/boot/grub/grub.cfg"
  fi

  if [[ -n "${LOOPBACK_CONFIG_FILE}" ]]; then
    echo "Using custom loopback.cfg: ${LOOPBACK_CONFIG_FILE}"
    cp -f "${LOOPBACK_CONFIG_FILE}" "${ISO_FILESYSTEM_DIR}/boot/grub/loopback.cfg"
  else
    echo "Patching existing loopback.cfg"
    patch_grub_file "${ISO_FILESYSTEM_DIR}/boot/grub/loopback.cfg"
  fi

  if [[ "${CONFIG_MODE}" == "nocloud" ]]; then
    echo "Embedding NoCloud seed at /nocloud"
    mkdir -p "${ISO_FILESYSTEM_DIR}/nocloud"
    cp -f "${AUTOINSTALL_CONFIG_FILE}" "${ISO_FILESYSTEM_DIR}/nocloud/user-data"
    if [[ -n "${METADATA_CONFIG_FILE}" ]]; then
      cp -f "${METADATA_CONFIG_FILE}" "${ISO_FILESYSTEM_DIR}/nocloud/meta-data"
    else
      : > "${ISO_FILESYSTEM_DIR}/nocloud/meta-data"
    fi
  else
    echo "Copying autoinstall to ISO root as /autoinstall.yaml"
    cp -f "${AUTOINSTALL_CONFIG_FILE}" "${ISO_FILESYSTEM_DIR}/autoinstall.yaml"
  fi
}

reassemble_iso() {
  echo "Rebuilding ISO -> ${DESTINATION_ISO}"
  xorriso -as mkisofs \
    -r -V "ubuntu-autoinstall-${TODAY}" -J -joliet-long -l \
    -iso-level 3 \
    -partition_offset 16 \
    --grub2-mbr "${BOOT_IMAGE_DIR}/${MBR_IMAGE}" \
    --mbr-force-bootable \
    -append_partition 2 0xEF "${BOOT_IMAGE_DIR}/${EFI_IMAGE}" \
    -appended_part_as_gpt \
    -c boot.catalog \
    -b boot/grub/i386-pc/eltorito.img \
    -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
    -eltorito-alt-boot \
    -e '--interval:appended_partition_2:all::' \
    -no-emul-boot \
    -o "${DESTINATION_ISO}" "${ISO_FILESYSTEM_DIR}"
  echo "Built: ${DESTINATION_ISO}"
}

main() {
  args "$@"
  create_tmp_dirs
  extract_iso
  configure_autoinstall
  reassemble_iso
}

main "$@"
