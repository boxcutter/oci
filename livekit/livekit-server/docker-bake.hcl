variable "IMAGE_NAME" {
    default =  "livekit-server"
  }

  variable "VERSION" {
    default = "1.8.3"
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
      LIVEKIT_URL_AMD64 = "https://github.com/livekit/livekit/releases/download/v1.8.3/livekit_1.8.3_linux_amd64.tar.gz"
      LIVEKIT_SHA256_AMD64 = "e9ccfc7aff3989ec753a1d1e009d0642d6b52f83ead1fe7d5b9120fcf5e8a8b0"
      LIVEKIT_URL_ARM64 = "https://github.com/livekit/livekit/releases/download/v1.8.3/livekit_1.8.3_linux_arm64.tar.gz"
      LIVEKIT_SHA256_ARM64 = "17951c82888ba40fb2c12d30deeb24ecf8ab21c9098ed4c6ad11f76e8d16f2eb"
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
