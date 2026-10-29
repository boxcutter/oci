variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/snmp-generator"
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
    SNMP_EXPORTER_SOURCE_URL = "https://github.com/prometheus/snmp_exporter/archive/refs/tags/v${VERSION}.tar.gz"
    SNMP_EXPORTER_SOURCE_SHA256 = "9c52951606f9138af758fd28693497181ad119b48433c0a542b4a2128049bd04"
    PEPLINK_SNMP_MIBS_URL = "https://download.peplink.com/resources/peplink_pepwave_snmp_mib-2024-07.zip"
    PEPLINK_SNMP_MIBS_SHA256 = "1e29f4b15304db7287b18d7c3465fdd8fa0cce278af28d5bfc835cfa5408bc21"
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
    "org.opencontainers.image.created" = "${timestamp()}"
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
