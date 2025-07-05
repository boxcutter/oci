variable "TAG_PREFIX" {
  default =  "docker.io/boxcutter/ros"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

variable "ROS_PACKAGE" {
  default = ["ros-core", "ros-base", "perception", "simulation", "desktop", "desktop-full"]
}

target "_common" {
  args = {
    ROS_PACKAGES_URI = "http://packages.ros.org/ros2/ubuntu"
    RAW_GITHUBUSERCONTENT_BASE_URL = "https://raw.githubusercontent.com"
  }
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "The Robot Operating System (ROS) is an open source project for building robot applications."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "ros/README.md"
  }
}

target "local" {
  name = "local-${ros_package}"
  inherits = ["_common"]
  matrix = {
    ros_package = ROS_PACKAGE
  }
  target = ros_package
  tags = [
    "${TAG_PREFIX}:kilted-${ros_package}-noble"
  ]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  name = "default-${ros_package}"
  inherits = ["_common"]
  matrix = {
    ros_package = ROS_PACKAGE
  }
  target = ros_package
  tags = [
    "${TAG_PREFIX}:kilted-${ros_package}-noble"
  ]
  platforms = ["linux/amd64", "linux/arm64/v8"]
}
