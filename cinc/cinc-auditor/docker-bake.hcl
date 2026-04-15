variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "7.0.107"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/7.0.107/ubuntu/24.04/cinc-auditor_7.0.107-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "c72bf4b05b9f16c7d9f2e8f0ebbeb24238964389c8901f84e11742324ca83b85"
    CINC_AUDITOR_URL_ARM64 = "https://downloads.cinc.sh/files/stable/cinc-auditor/7.0.107/ubuntu/24.04/cinc-auditor_7.0.107-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "292c06bf4c40c28d557a0bd5e91a7dc22408aa650971a210c71ecba1454c0f64"
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
