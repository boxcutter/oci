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
    CINC_URL_AMD64 = "http://downloads.cinc.sh/files/stable/cinc/18.3.0/el/7/cinc-18.3.0-1.el7.aarch64.rpm"
    CINC_SHA256_AMD64 = "32d286662ba3f0d4f7542713136b068ccd203704b8b04b787814ddc87ad86611"
    CINC_URL_ARM64 = "http://downloads.cinc.sh/files/stable/cinc/18.3.0/el/7/cinc-18.3.0-1.el7.x86_64.rpm"
    CINC_SHA256_ARM64 = "50f90e23354e0223baea35187a53fa457ca28050051daac980c513c7549cc586"
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
