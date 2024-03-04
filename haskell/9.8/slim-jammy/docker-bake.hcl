variable "IMAGE_NAME" {
  default = "haskell"
}

variable "VERSION" {
  default = "9.8.2"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    GHC_VERSION = "${VERSION}"
    GHC_URL_AMD64 = "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-ubuntu20_04-linux.tar.xz"
    GHC_SHA256_AMD64 = "a65a4726203c606b58a7f6b714a576e7d81390158c8afa0dece3841a4c602de2"
    GHC_URL_ARM64 = "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-aarch64-deb11-linux.tar.xz"
    GHC_SHA256_ARM64 = "b7f27d53cf20645833bcff2fa6308b221c39eeac1de3fe074598090731848672"
    GHC_RELEASE_KEY = "88B57FCF7DB53B4DB3BFA4B1588764FBE22D19C4"
    STACK_URL_AMD64 = "https://github.com/commercialhaskell/stack/releases/download/v2.15.1/stack-2.15.1-linux-x86_64.tar.gz"
    STACK_SHA256_AMD64 = "3e8d85c4c9d24905498edc8c0ec0b4fa207093d9817f281d842c203f33ad9f5e"
    STACK_URL_ARM64 = "https://github.com/commercialhaskell/stack/releases/download/v2.15.1/stack-2.15.1-linux-aarch64.tar.gz"
    STACK_SHA256_ARM64 = "450126245044aa37ea8ba33f70c3c5bad331a3b4d3138f7b7ad0dee2a4ca1613"
    STACK_RELEASE_KEY = "C5705533DA4F78D8664B5DC0575159689BEFB442"
    CABAL_INSTALL_URL_AMD64 = "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-linux-ubuntu20_04.tar.xz"
    CABAL_INSTALL_SHA256_AMD64 = "c2a8048caa3dbfe021d0212804f7f2faad4df1154f1ff52bd2f3c68c1d445fe1"
    CABAL_INSTALL_URL_ARM64 = "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-linux-deb11.tar.xz"
    CABAL_INSTALL_SHA256_ARM64 = "daa767a1b844fbc2bfa0cc14b7ba67f29543e72dd630f144c6db5a34c0d22eb1"
    CABAL_INSTALL_SHA256SUMS_URL = "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/SHA256SUMS"
    CABAL_INSTALL_RELEASE_KEY = "EAF2A9A722C0C96F2B431CA511AAD8CEDEE0CAEF"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-slim-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-slim-jammy",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Haskell is an advanced purely-functional programming language."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "haskell/README.md"
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
