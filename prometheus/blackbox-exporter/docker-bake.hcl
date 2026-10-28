variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/blackbox-exporter"
}

variable "VERSION" {
  default = "0.29.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.29.1/blackbox_exporter-0.29.1.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "b82b81839e6317e84fdd367f46d7ddd3b773fa09cbe2e3d5633a59171d741e76"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.29.1/blackbox_exporter-0.29.1.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "c597b0d442c02c0f2c8f691cbc7784216c786fada28f300c7b914e1f94523834"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Blackbox exporter for probing remote machine metrics."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/blackbox-exporter/README.md"
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
