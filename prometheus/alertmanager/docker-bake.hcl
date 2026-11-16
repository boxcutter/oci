variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/alertmanager"
}

variable "VERSION" {
  default = "0.35.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    ALERTMANAGER_URL_AMD64 = "https://github.com/prometheus/alertmanager/releases/download/v0.35.0/alertmanager-0.35.0.linux-amd64.tar.gz"
    ALERTMANAGER_SHA256_AMD64 = "6c7752a903c40c8a749e0b29df9240437e4fbb8228068d0af8807377db32addd"
    ALERTMANAGER_URL_ARM64 = "https://github.com/prometheus/alertmanager/releases/download/v0.35.0/alertmanager-0.35.0.linux-arm64.tar.gz"
    ALERTMANAGER_SHA256_ARM64 = "b7a8a69f849c6f837348b05476195862152f9de8eae338eb36ab29801d341654"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus Alertmanager."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
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
