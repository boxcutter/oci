variable "IMAGE_NAME" {
  default =  "prometheus"
}

variable "VERSION" {
  default = "2.43.0"
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
    PROMETHEUS_URL_AMD64 = "https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz"
    PROMETHEUS_SHA256_AMD64 = "cfea92d07dfd9a9536d91dff6366d897f752b1068b9540b3e2669b0281bb8ebf"
    PROMETHEUS_URL_ARM64 = "https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-arm64.tar.gz"
    PROMETHEUS_SHA256_ARM64 = "79c4262a27495e5dff45a2ce85495be2394d3eecd51f0366c706f6c9c729f672"
    PROMETHEUS_URL_ARMHF = "https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-armv7.tar.gz"
    PROMETHEUS_SHA256_ARMHF = "2c973310a4be2792d80016102ec115800493a322c301fd51da57469374f274af"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus monitoring system and time series database."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "prometheus/prometheus/README.md"
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
