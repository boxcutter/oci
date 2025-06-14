variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/blackbox-exporter"
}

variable "VERSION" {
  default = "0.26.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "4b1bb299c685ecff75d41e55e90aae8e02a658395fb14092c7f9c5c9d75016c7"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "afb5581b1d4ea45078eebc96e4f989f912d1144d2cc131db8a6c0963bcc6a654"
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
