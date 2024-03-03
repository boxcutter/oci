variable "IMAGE_NAME" {
  default =  "erlang"
}

variable "VERSION" {
  default = "26.1.2.0"
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
    OTP_VERSION = "26.2.2"
    OTP_DOWNLOAD_SHA256 = "93c09aa8814018c23d218ac68b2bcdba188e12086223fbfa08af5cc70edd7ee1"
    REBAR3_VERSION = "3.22.1"
    REBAR3_DOWNLOAD_SHA256 = "2855b5784300865d2e43cb7a135cb2bba144cf15214c619065b918afc8cc6eb9"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Erlang is a programming language used to build massively scalable systems with high availability."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "erlang/README.md"
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