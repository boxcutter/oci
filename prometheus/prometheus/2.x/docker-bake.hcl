variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/prometheus"
}

variable "VERSION" {
  default = "2.55.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "19700bdd42ec31ee162e4079ebda4cd0a44432df4daa637141bdbea4b1cd8927"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "af43368bc6379c3c8bd5ac0b82208060bba22267bf01ad3ab5df56ad5725bf88"
    PROMETHEUS_URL_ARMHF = "https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-armv7.tar.gz"
    PROMETHEUS_SHA256_ARMHF = "243f179a86c182a2fc1ba43a9df01620a25f6d256fd5b2f84e2803ce6da971a8"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus monitoring system and time series database."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/prometheus/README.md"
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
