variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "3.4.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v3.4.1/prometheus-3.4.1.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "09203151c132f36b004615de1a3dea22117ad17e6d7a59962e34f3abf328f312"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v3.4.1/prometheus-3.4.1.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "2a85be1dff46238c0d799674e856c8629c8526168dd26c3de2cecfbfc6f9a0a2"
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
