variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

variable "IMAGE_NAME" {
  default = "nvidia-l4t-ros"
}

target "default" {
  name = "${IMAGE_NAME}-${ros_version}-${ros_package}-${replace(base_image, ".", "-")}"
  args = {
    BASE_IMAGE = docker.io/boxcutter/nvidia-l4t-jetpack:${base_image}
    ROS_VERSION = ros_version
    ROS_PACKAGE = ros_package
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${ros_version}-${ros_package}-${base_image}"
  ]
  dockerfile = "Containerfile"
  platforms = ["linux/arm64/v8"]
  labels = {
    "org.opencontainers.image.created" = timestamp()
    "org.opencontainers.image.description" = "NVIDIA JetPack SDK."
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
  }
  matrix = {
    base_image = ["r35.3.1", "r35.4.1"]
    ros_version = ["humble", "iron"]
    ros_package = ['ros_base', 'ros_core', 'desktop']
  }
}