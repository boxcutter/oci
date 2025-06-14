variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/node-exporter"
}

variable "VERSION" {
  default = "1.9.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    NODE_EXPORTER_URL_AMD64 = "https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz"
    NODE_EXPORTER_SHA256_AMD64 = "becb950ee80daa8ae7331d77966d94a611af79ad0d3307380907e0ec08f5b4e8"
    NODE_EXPORTER_URL_ARM64 = "https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-arm64.tar.gz"
    NODE_EXPORTER_SHA256_ARM64 = "848f139986f63232ced83babe3cad1679efdbb26c694737edc1f4fbd27b96203"
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
