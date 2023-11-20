variable "IMAGE_NAME" {
  default =  "doctl"
}

variable "VERSION" {
  default = "1.93.1"
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
    DOCTL_VERSION = "${VERSION}"
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.93.1/doctl-1.93.1-linux-amd64.tar.gz"    
    DOCTL_SHA256_AMD64 = "b84c96443815a4ee8857c82eba47e36cec953eb9d3f5c542a2c2ab9868f40f4f"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.93.1/doctl-1.93.1-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "6ea1955fd2e63937101549b6895272b71f21c83f3563cc9911f1b1891b34690c"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
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