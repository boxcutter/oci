variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/alertmanager"
}

variable "VERSION" {
  default = "0.34.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    ALERTMANAGER_URL_AMD64 = "https://github.com/prometheus/alertmanager/releases/download/v0.34.1/alertmanager-0.34.1.linux-amd64.tar.gz"
    ALERTMANAGER_SHA256_AMD64 = "265b9d1e55ef0d5306a436018af6d2b686c2ce051f03d968f7464ecb1372a7e8"
    ALERTMANAGER_URL_ARM64 = "https://github.com/prometheus/alertmanager/releases/download/v0.34.1/alertmanager-0.34.1.linux-arm64.tar.gz"
    ALERTMANAGER_SHA256_ARM64 = "d98d6cbaf52151c7e76e24355fec88b11cebcb9875d4cdd8b76ddce7a7e5535c"
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
