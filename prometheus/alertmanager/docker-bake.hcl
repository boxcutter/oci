variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/alertmanager"
}

variable "VERSION" {
  default = "0.30.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    ALERTMANAGER_URL_AMD64 = "https://github.com/prometheus/alertmanager/releases/download/v0.30.0/alertmanager-0.30.0.linux-amd64.tar.gz"
    ALERTMANAGER_SHA256_AMD64 = "86fd95034e3e17094d6951118c54b396200be22a1c16af787e1f7129ebce8f1f"
    ALERTMANAGER_URL_ARM64 = "https://github.com/prometheus/alertmanager/releases/download/v0.30.0/alertmanager-0.30.0.linux-arm64.tar.gz"
    ALERTMANAGER_SHA256_ARM64 = "061a5ab3998fb8af75192980a559c7bfa3892da55098da839d7a79d94abe0b61"
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
