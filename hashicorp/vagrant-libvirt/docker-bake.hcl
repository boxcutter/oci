variable "IMAGE_NAME" {
  default = "vagrant-libvirt"
}

variable "VERSION" {
  default = "2.4.1"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    VAGRANT_VERSION = "${VERSION}"
    VAGRANT_URL_AMD64 = "https://releases.hashicorp.com/vagrant/2.4.1/vagrant_2.4.1-1_amd64.deb"
    VAGRANT_SHA256_AMD64 = "7d379e99eb757b81f31993634b34a3317d2b79607e2a20dab9b7071f4b278810"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "MIT"
    "org.opencontainers.image.description" = ""
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64"]
}  
