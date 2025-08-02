variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "18.7.6"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/18.7.6/el/8/cinc-18.7.6-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "06ddc98b99f9d41da066ee472ceccbf9815682856da302e0c32781ee2edd77b3"
    CINC_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc/18.7.6/el/8/cinc-18.7.6-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "64ac3ae37f72d96f077584f82b916d7d6c53eb03cb95228d9015d6c179eb0a53"
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
