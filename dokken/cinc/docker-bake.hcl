variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc"
}

variable "VERSION" {
  default = "18.0.185"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc/18.0.185/el/8/cinc-18.0.185-1.el8.x86_64.rpm"
    CINC_SHA256_AMD64 = "b5cf532168edda95d929963cf78541e802b97d4a694394207a9d7e17217d11f2"
    CINC_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc/18.0.185/el/8/cinc-18.0.185-1.el8.aarch64.rpm"
    CINC_SHA256_ARM64 = "bed837fdeaa0d82ddcd7b99b9052ae1e3c4d4a75126ee6a3f06e8ccdee75dd81"
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
