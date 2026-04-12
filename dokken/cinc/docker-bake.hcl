variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "18.9.4"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "https://ftp.osuosl.org/pub/cinc/files/stable/cinc/18.9.4/el/8/cinc-18.9.4-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "b54f43f399cb888cdcdf08502391c7e162854f1b50ecf8b8ad4425c6924e2e58"
    CINC_URL_ARM64 = "https://ftp.osuosl.org/pub/cinc/files/stable/cinc/18.9.4/el/8/cinc-18.9.4-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "c2aea1b1b0e8868603ff71a9bdeb29da9a68654d31adfa85f41da64cc66c3bf3"
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
