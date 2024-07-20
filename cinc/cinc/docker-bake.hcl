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
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/18.5.0/el/8/cinc-18.5.0-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "decc830c6111a907aea81d62d21059e76695397e236cf6e4ea53e0d9e6df5af0"
    CINC_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc/18.5.0/el/8/cinc-18.5.0-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "3b8d728af8c3b6b3bec7eee088e45143194deadbb3adbcc58d652e2a90f30e54"
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
