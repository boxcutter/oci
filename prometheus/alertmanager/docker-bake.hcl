variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/alertmanager"
}

variable "VERSION" {
  default = "0.27.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    ALERTMANAGER_URL_AMD64 = "https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz"
    ALERTMANAGER_SHA256_AMD64 = "23c3f5a3c73de91dbaec419f3c492bef636deb02680808e5d842e6553aa16074"
    ALERTMANAGER_URL_ARM64 = "https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-arm64.tar.gz"
    ALERTMANAGER_SHA256_ARM64 = "a754304b682cec61f4bd5cfc029b451a30134554b3a2f21a9c487e12814ff8f3"
    ALERTMANAGER_URL_ARMHF = "https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-armv7.tar.gz"
    ALERTMANAGER_SHA256_ARMHF = "10800f0256873c2eed843297f2a49958f743f6497eada7f7fb8f35aa1d009b53"
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
