setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "defaults to all platforms and plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-platforms.sh
  popd
  assert_output 'linux/arm64,linux/amd64,linux/arm/v7'
}

@test "defaults to all platforms with csv" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-platforms.sh -c
  popd
  assert_output '"linux/arm64","linux/amd64","linux/arm/v7"'
}

@test "defaults to all platforms with plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-platforms.sh -t
  popd
  assert_output 'linux/arm64,linux/amd64,linux/arm/v7'
}

@test "defaults to all platforms with toml that has name and tags" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-tags
  run list-platforms.sh
  popd
  assert_output 'linux/arm64,linux/amd64,linux/arm/v7'
}

# @test "defaults to all platforms with toml that has name and tags" {
#   pushd $PROJECT_ROOT/test/fixture/image-toml-name-tags
#   run list-platforms.sh
#   popd
#   assert_output 'linux/arm64,linux/amd64,linux/arm/v7'
# }

@test "reads platforms from toml" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms
  run list-platforms.sh
  popd
  assert_output 'linux/arm64,linux/amd64'
}

@test "reads platforms from toml with csv" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms
  run list-platforms.sh -c
  popd
  assert_output '"linux/arm64","linux/amd64"'
}

@test "reads platforms from toml with plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms
  run list-platforms.sh -t
  popd
  assert_output 'linux/arm64,linux/amd64'
}
