variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "6.8.24"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/6.8.24/ubuntu/24.04/cinc-auditor_6.8.24-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "13907518ae88cc12d85fb09e2bca5c6f48d9ced75fe1dad61285d1d884cda9c7"
    CINC_AUDITOR_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/6.8.24/ubuntu/24.04/cinc-auditor_6.8.24-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "7453d58358cc158ddfe7a92a4557966c1e4b472e207e6097cf2490b323bd2616"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Cinc Auditing and Testing Framework."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.test.container-build-publish-action.run-test-stage" = "false" }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
}
