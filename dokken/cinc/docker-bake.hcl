variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "18.4.12"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc/18.4.12/el/7/cinc-18.4.12-1.el7.x86_64.rpm"
    CINC_SHA256_AMD64 = "697ac775c15aa80ca9908ae404e98fb93b4f71545d1b01ddcc7364c9070ba8b2"
    CINC_URL_ARM64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc/18.4.12/el/7/cinc-18.4.12-1.el7.aarch64.rpm"
    CINC_SHA256_ARM64 = "dbce991933bc0fd0ddd70403fb103a86459db20de13dc3c4d001df83b86c5796"
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
