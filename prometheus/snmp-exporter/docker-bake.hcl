variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/snmp-exporter"
}

variable "VERSION" {
  default = "0.29.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    SNMP_EXPORTER_URL_AMD64 = "https://github.com/prometheus/snmp_exporter/releases/download/v0.29.0/snmp_exporter-0.29.0.linux-amd64.tar.gz"
    SNMP_EXPORTER_SHA256_AMD64 = "fd7ded886180063a8f77e1ca18cc648e44b318b9c92bcb3867b817d93a5232d6"
    SNMP_EXPORTER_URL_ARM64 = "https://github.com/prometheus/snmp_exporter/releases/download/v0.29.0/snmp_exporter-0.29.0.linux-arm64.tar.gz"
    SNMP_EXPORTER_SHA256_ARM64 = "e590870ad2fcd39ea9c7d722d6e85aa6f1cc9e8671ff3f17feba12a6b5a3b47a"
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
