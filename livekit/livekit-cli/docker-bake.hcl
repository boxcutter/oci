variable "IMAGE_NAME" {
    default =  "livekit-cli"
  }

  variable "VERSION" {
    default = "2.3.1"
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
      LIVEKIT_URL_AMD64 = "https://github.com/livekit/livekit-cli/releases/download/v2.3.1/lk_2.3.1_linux_amd64.tar.gz"
      LIVEKIT_SHA256_AMD64 = "cec1e52df098137691f0378d3fc62b036ff87a95f7936e6990a3158959b76877"
      LIVEKIT_URL_ARM64 = "https://github.com/livekit/livekit-cli/releases/download/v2.3.1/lk_2.3.1_linux_arm64.tar.gz"
      LIVEKIT_SHA256_ARM64 = "6aafaf9cdfcd3820270f351ae6f79844beafc2f87291c232141757218c1293a9"
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
