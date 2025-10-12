variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "18.8.9"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/18.8.9/el/8/cinc-18.8.9-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "f775d0e41687f728d7bac8195feaa73209903b25ff7df4585217576baddda053"
    CINC_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc/18.8.9/el/8/cinc-18.8.9-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "383e43cd2ef1089b180a84fd1019520d5570af48f177faeeb41c8e944deabb57"
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
