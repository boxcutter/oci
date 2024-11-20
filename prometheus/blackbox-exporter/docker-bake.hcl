variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/blackbox-exporter"
}

variable "VERSION" {
  default = "0.25.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "c651ced6405c5e0cd292a400f47ae9b34f431f16c7bb098afbcd38f710144640"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "46ec5a54a41dc1ea8a8cecee637e117de4807d3b0976482a16596e82e79ac484"
    BLACKBOX_EXPORTER_URL_ARMHF = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-armv7.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARMHF = "4a275bf8c0b83fcac3db9afb7099b33fdc52ff267e2852a72b62f5611ab540f0"
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
