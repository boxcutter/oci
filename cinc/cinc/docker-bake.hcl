variable "IMAGE_NAME" {
  default =  "cinc"
}

variable "VERSION" {
  default = "18.4.2"
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
    CINC_URL_AMD64 = "http://downloads.cinc.sh/files/stable/cinc/18.4.2/ubuntu/22.04/cinc_18.4.2-1_amd64.deb"
    CINC_SHA256_AMD64 = "ce16e634d9f5ca41765a233e56f327ed0b1a3a2ac81844956261f6121c896f8e"
    CINC_URL_ARM64 = "http://downloads.cinc.sh/files/stable/cinc/18.4.2/ubuntu/22.04/cinc_18.4.2-1_arm64.deb"
    CINC_SHA256_ARM64 = "165dba28364aa45456684578073e32e54d1c1fa3dc69814cc55a8b1332712e34"
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
