variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/eclipse-temurin"
}

variable "VERSION" {
  default = "21.0.13_9"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"

  tags = [
    "${TAG_PREFIX}:${VERSION}-jre-resolute",
    "${TAG_PREFIX}:21-jre-resolute",
    "${TAG_PREFIX}:${VERSION}-jre",
    "${TAG_PREFIX}:21-jre",
  ]

  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "GPL-2.0-only WITH Classpath-exception-2.0"
    "org.opencontainers.image.description" = "Eclipse Temurin OpenJDK 21 Java Runtime Environment."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "openjdk/eclipse-temurin/README.md"
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
