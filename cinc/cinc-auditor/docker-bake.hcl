variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "6.8.11"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc-auditor/6.8.11/ubuntu/24.04/cinc-auditor_6.8.11-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "6bf61e0263b47693c4eb9326ed2d69f1b9fa94ab5d7b9623694a5df49b58b369"
    CINC_AUDITOR_URL_ARM64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc-auditor/6.8.11/ubuntu/24.04/cinc-auditor_6.8.11-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "d37ad6a477fca0e760202e8152fd74143f3e6c02e5cbe61c56f5e3e47f826339"
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
    "dev.polymathrobotics.test.container-build-publish-action.run-test-stage" = "false" }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
}
