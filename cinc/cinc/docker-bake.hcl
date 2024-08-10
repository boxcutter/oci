variable "IMAGE_NAME" {
  default =  "cinc"
}

variable "VERSION" {
  default = "18.5.0"
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
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/18.5.0/el/9/cinc-18.5.0-1.el9.x86_64.rpm"
    CINC_SHA256_AMD64 = "644a0bf1de601d886a6886bd099523704c948c1f49fccc4b97b3f074388db081"
    CINC_URL_ARM64 = "https://ftp.osuosl.org/pub/cinc/files/stable/cinc/18.5.0/el/9/cinc-18.5.0-1.el9.aarch64.rpm"
    CINC_SHA256_ARM64 = "9cb55dcc3763a8669c1f701af94c1fda0e6ccfc76c41e4ee76f8de6534f9bca9"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:current"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Cinc Client is an automation platform built from Chef Infra"
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
