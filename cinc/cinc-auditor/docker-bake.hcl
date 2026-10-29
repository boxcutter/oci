variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "7.3.4"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/${VERSION}/ubuntu/26.04/cinc-auditor_${VERSION}-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "d36be4dd21ad074ae804d32aea59f8f8773a7dda7cdc94f7caceb81a7186d1b5"
    CINC_AUDITOR_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/${VERSION}/ubuntu/26.04/cinc-auditor_${VERSION}-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "141fa1aa4c63ce92d0a12094003247ab909f3775aa3fb83f75247a6364ec19e5"
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
    "dev.boxcutter.image.readme-filepath" = "cinc/cinc-auditor/README.md"
    "dev.boxcutter.test.container-build-publish-action.run-test-stage" = "false"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64"]
}
