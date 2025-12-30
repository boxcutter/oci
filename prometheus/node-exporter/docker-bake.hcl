variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/node-exporter"
}

variable "VERSION" {
  default = "1.10.2"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    NODE_EXPORTER_URL_AMD64 = "https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz"
    NODE_EXPORTER_SHA256_AMD64 = "c46e5b6f53948477ff3a19d97c58307394a29fe64a01905646f026ddc32cb65b"
    NODE_EXPORTER_URL_ARM64 = "https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-arm64.tar.gz"
    NODE_EXPORTER_SHA256_ARM64 = "de69ec8341c8068b7c8e4cfe3eb85065d24d984a3b33007f575d307d13eb89a6"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus node exporter for machine metrics."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/node-exporter/README.md"
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
