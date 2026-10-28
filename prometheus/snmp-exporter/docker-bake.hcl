variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/snmp-exporter"
}

variable "VERSION" {
  default = "0.31.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    SNMP_EXPORTER_URL_AMD64 = "https://github.com/prometheus/snmp_exporter/releases/download/v0.31.0/snmp_exporter-0.31.0.linux-amd64.tar.gz"
    SNMP_EXPORTER_SHA256_AMD64 = "264d1b3be8dd1133fcbd11cbb81ab2a65f121237ab2fff198adb1cc6961ed3ae"
    SNMP_EXPORTER_URL_ARM64 = "https://github.com/prometheus/snmp_exporter/releases/download/v0.31.0/snmp_exporter-0.31.0.linux-arm64.tar.gz"
    SNMP_EXPORTER_SHA256_ARM64 = "a854feb530c16e7e4aa5d4d96f9d44f98320c415b5048e93e152593412ffaac8"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "SNMP Exporter"
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/snmp-exporter/README.md"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
}
