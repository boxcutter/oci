setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "uses directory as image name default" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run full-image-name.sh
  popd
  assert_output 'docker.io/boxcutter/image-no-toml'
}

@test "reads image name from toml" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name
  run full-image-name.sh
  popd
  assert_output 'docker.io/boxcutter/example'
}
