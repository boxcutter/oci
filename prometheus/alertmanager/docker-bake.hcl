variable "IMAGE_NAME" {
  default =  "alertmanager"
}

variable "VERSION" {
  default = "0.26.0"
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
    ALERTMANAGER_URL_AMD64 = "https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz"
    ALERTMANAGER_SHA256_AMD64 = "abd73e2ee6bf67d3888699660abbecba7b076bf1f9459a3a8999d493b149ffa6"
    ALERTMANAGER_URL_ARM64 = "https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-arm64.tar.gz"
    ALERTMANAGER_SHA256_ARM64 = "f65969661821570929ad34cf64e034fe72c8e014855d244321c67a0c3ce3fc08"
    ALERTMANAGER_URL_ARMHF = "https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-armv7.tar.gz"
    ALERTMANAGER_SHA256_ARMHF = "1a88a94c1f6cce900f49daba6142a5900afc92619ce98864663338d74bcf1685"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus Alertmanager."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/alertmanager/README.md"
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
