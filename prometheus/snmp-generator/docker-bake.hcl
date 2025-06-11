variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/snmp-generator"
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
    SNMP_EXPORTER_SOURCE_URL = "https://github.com/prometheus/snmp_exporter/archive/refs/tags/v0.29.0.tar.gz"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus SNMP generator."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/snmp-generator/README.md"
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
