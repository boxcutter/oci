variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "2.53.4"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "b8b497c4610d1b93208252b60c8f20f6b2e78596ae8df43397a2e805aa53d475"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v2.53.4/prometheus-2.53.4.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "ec7236ecea7154d0bfe142921708b1ae7b5e921e100e0ee85ab92b7c444357e0"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
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
