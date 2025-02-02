variable "IMAGE_NAME" {
  default =  "pgweb"
}

variable "VERSION" {
  default = "0.14.3"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    PGWEB_URL_AMD64 = "https://github.com/sosedoff/pgweb/releases/download/v0.14.3/pgweb_linux_amd64.zip"
    PGWEB_SHA256_AMD64 = "cb4e8135b1e9da27a8c2f7ab868c6f2df4ff4a4a13f63ffce206e2b9918a2763"
    PGWEB_URL_ARM64 = "https://github.com/sosedoff/pgweb/releases/download/v0.14.3/pgweb_linux_arm64.zip"
    PGWEB_SHA256_ARM64 = "749078cb0b164725d3a2cbe5368aa5bedd023b35700a460ed7987dc1dd147973"
    PGWEB_URL_ARMHF = "https://github.com/sosedoff/pgweb/releases/download/v0.14.3/pgweb_linux_arm_v5.zip"
    PGWEB_SHA256_ARMHF = "e8aaa56862b5205485da55ffe69a347dbb26bdebef604ff7e5b4c9abc7701667"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Blackbox exporter for probing remote machine metrics."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "prometheus/blackbox_exporter/README.md"
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
