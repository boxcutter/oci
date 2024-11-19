variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "3.0.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v3.0.0/prometheus-3.0.0.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "614ce24f4802f1a2d3dc35ab9bd35047f428469c7e029163602a40078bf7508b"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v3.0.0/prometheus-3.0.0.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "b2e6947d5fad863c89f56cee8047e8f57b63fde6b41c918300e1e88c1c62d1b5"
    PROMETHEUS_URL_ARMHF = "https://github.com/prometheus/prometheus/releases/download/v3.0.0/prometheus-3.0.0.linux-armv7.tar.gz"
    PROMETHEUS_SHA256_ARMHF = "e97e9c9bbc86e2972de9f5db0ac1036e950784316cc0ba70a6fc0b3852cccef5"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus monitoring system and time series database."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/prometheus/README.md"
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
