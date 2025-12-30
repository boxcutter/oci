variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/blackbox-exporter"
}

variable "VERSION" {
  default = "0.28.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.28.0/blackbox_exporter-0.28.0.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "caf5d242fb1cf6d5cb678f3f799f22703d4fafea26b03dcbbd7e1f1825e06329"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.28.0/blackbox_exporter-0.28.0.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "63312be0983d85e5109710a7dc93df3051157ae581853fa3655d171cc1b2806e"
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
