variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "3.15.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v3.15.1/prometheus-3.15.1.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "6a726885328ad9efebbf36e876ce2fb6225468a71fd1e7ce3ba666d5f4d97a84"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v3.15.1/prometheus-3.15.1.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "ceb6d21493c37ca0b4513b147642797c68cf39a0f50a444d50e1e80c74f21b26"
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
