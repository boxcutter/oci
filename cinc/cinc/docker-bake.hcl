variable "IMAGE_NAME" {
  default =  "cinc"
}

variable "VERSION" {
  default = "18.3.0"
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
    CINC_URL_AMD64 = "http://downloads.cinc.sh/files/stable/cinc/18.3.0/ubuntu/22.04/cinc_18.3.0-1_amd64.deb"
    CINC_SHA256_AMD64 = "0cb609faf055c3c43a23be755cc869b404df21d91876cad7981a6d2956ef1f7e"
    CINC_URL_ARM64 = "http://downloads.cinc.sh/files/stable/cinc/18.3.0/ubuntu/22.04/cinc_18.3.0-1_arm64.deb"
    CINC_SHA256_ARM64 = "db9a4cfbc463697c1e4cea2fc40c32863bc03469c28af86c32a43f21ae8aeb15"
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
