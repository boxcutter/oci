variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "17.10.165"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/17.10.165/el/8/cinc-17.10.165-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "f36d9bcc01f6d4de65eefede1f2c21bdcaeef1907e19ed6c1fe9db54e1ef160b"
    CINC_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc/17.10.165/el/8/cinc-17.10.165-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "b3651a41dea5f2d4c6323bdb4a23e86d8f6bf395b0b35f8dadadafde9b1bb59c"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest",
    "${TAG_PREFIX}:current"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Cinc Client is an automation platform built from Chef Infra"
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.container-build-publish-action.test-entrypoint" = "/bin/sh"
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
