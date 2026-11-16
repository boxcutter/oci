variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "3.16.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v3.16.0/prometheus-3.16.0.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "68727009472a2c02e1ff7f062fd5b3e637285bffc8fc2d340c76fb449d6e0f34"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v3.16.0/prometheus-3.16.0.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "fd8571b8162f4020232d886f17340bcf92e1722985ae3b4c1d096157826c0fbe"
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
