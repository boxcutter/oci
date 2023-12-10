variable "IMAGE_NAME" {
  default =  "pgweb"
}

variable "VERSION" {
  default = "0.14.2"
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
    PGWEB_URL_AMD64 = "https://github.com/sosedoff/pgweb/releases/download/v0.14.2/pgweb_linux_amd64.zip"
    PGWEB_SHA256_AMD64 = "0a35e450f1a7bdf5aa23fe56f5203e5400f47e7fa62d83f6433f7e8a8121de6a"
    PGWEB_URL_ARM64 = "https://github.com/sosedoff/pgweb/releases/download/v0.14.2/pgweb_linux_arm64.zip"
    PGWEB_SHA256_ARM64 = "588608795c70d6f75ccacbb0899cc792366deb47d5608545be4bba3c6deba6e3"
    PGWEB_URL_ARMHF = "https://github.com/sosedoff/pgweb/releases/download/v0.14.2/pgweb_linux_arm_v5.zip"
    PGWEB_SHA256_ARMHF = "2fdd5e94e78d9ff8bd498aeaf135cfd513cceaab08101b84c9e5ab61b8fb61e1"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Blackbox exporter for probing remote machine metrics."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "prometheus/blackbox_exporter/README.md"
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
