variable "IMAGE_NAME" {
  default =  "prometheus"
}

variable "VERSION" {
  default = "2.49.1"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v2.50.1/prometheus-2.50.1.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "936f3777f8c3a4a90d3c58a6f410350d5932c79367b99771d002bd36e48bd05b"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v2.50.1/prometheus-2.50.1.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "9f1a65cf08cef3dcd5f0d38d8673ecfaf1054aa9e1e5c18c94efd8546c1fdd96"
    PROMETHEUS_URL_ARMHF = "https://github.com/prometheus/prometheus/releases/download/v2.50.1/prometheus-2.50.1.linux-armv7.tar.gz"
    PROMETHEUS_SHA256_ARMHF = "3ec3073dec3dfd874ebe74620b6ed1dc9a030379cdff46ad816a6e95b85316d8"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus monitoring system and time series database."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
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
