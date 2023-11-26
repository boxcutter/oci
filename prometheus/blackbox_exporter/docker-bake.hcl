variable "IMAGE_NAME" {
  default =  "blackbox_exporter"
}

variable "VERSION" {
  default = "0.23.0"
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
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "63bd4fde6984db79c95e1502a0ab47da6194d763bff22a04d1f50c4fd8322b84"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "4750a91055a53093c7fdb4817ca39ba02b429232b0ac659de3cbe156d018b8fd"
    BLACKBOX_EXPORTER_URL_ARMHF = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.23.0/blackbox_exporter-0.23.0.linux-armv7.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARMHF = "1fdd52e860f358e6f514fe3372cbd238d2fe4a82ca2e4116c02d9e5b263c61c6"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Blackbox exporter for probing remote machine metrics."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "prometheus/blackbox_exporter/README.md"
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
