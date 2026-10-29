variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/meshcmd"
}

# meshcentral.com only publishes the latest meshcmd at an unversioned URL, so
# the checksums pin the binary. If they stop matching, upstream published a new
# build: check the version it reports and update VERSION and the checksums.
variable "VERSION" {
  default = "1.1.9"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  args = {
    MESHCMD_URL_AMD64 = "https://meshcentral.com/executables/meshcmd-linux-x86-64"
    MESHCMD_SHA256_AMD64 = "7aacae72f0951c8f327d6a623199c1f68037c4cb3ec5e4a731ba017a84fa0dde"
    MESHCMD_URL_ARM64 = "https://meshcentral.com/executables/meshcmd-linux-arm-64"
    MESHCMD_SHA256_ARM64 = "9b9ae3b4cd3a5a0689dd85ea3aa9fe96aaf54c5a29fb623d7a327880539b9fe7"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Command line tool used to perform many tasks related to computer management of Intel Active Management Technology (AMT) devices."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "meshcmd/README.md"
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
