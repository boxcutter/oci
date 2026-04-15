variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "7.0.95"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/7.0.95/ubuntu/24.04/cinc-auditor_7.0.95-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "7eed263d8eec95e7ff1e829b09cb75fdfd4522a972aa367c6ea7d5a4fde7f4c9",
    CINC_AUDITOR_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/7.0.95/ubuntu/24.04/cinc-auditor_7.0.95-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "aa68e0ec2139f167c6f503c6818f528db025b5cf710bd15ffcbbe2467323811f"
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
