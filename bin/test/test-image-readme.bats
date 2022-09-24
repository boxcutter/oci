setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "uses directory for readme by default" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run image-readme.sh
  popd
  assert_output 'image-no-toml/README.md'
}

@test "uses directory for readme with toml and readme parameter" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name
  run image-readme.sh
  popd
  assert_output 'image-toml-name/README.md'
}

@test "reads readme from toml" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-readme
  run image-readme.sh
  popd
  assert_output 'example/README.md'
}
