variable "IMAGE_NAME" {
  default = "doctl"
}

variable "VERSION" {
  default = "1.104.0"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "f758b0c2fb7857db2bd00439155154f2ab8bee71c4f3640f90f64ec35256ca53"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "c98ef379b6fb43a342e537cfa45ac90910c8ee4a9bea34105234c1a7652f8fc8"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Digital Ocean command-line interface."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
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
