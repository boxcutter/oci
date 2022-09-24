setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "default tag is nothing" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-tags.sh
  popd
  assert_output 'docker.io/boxcutter/image-no-toml'
}

@test "defaults tag is nothing with csv" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-tags.sh -c
  popd
  assert_output 'docker.io/boxcutter/image-no-toml'
}

@test "defaults tag is nothing with plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-no-toml
  run list-tags.sh -t
  popd
  assert_output 'docker.io/boxcutter/image-no-toml'
}

@test "reads tags from toml" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms-tags
  run list-tags.sh
  popd
  assert_output --partial 'docker.io/boxcutter/example:1.2.3'
  assert_output --partial 'docker.io/boxcutter/example:latest'
}

@test "reads tags from toml with plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms-tags
  run list-tags.sh -t
  popd
  assert_output --partial 'docker.io/boxcutter/example:1.2.3'
  assert_output --partial 'docker.io/boxcutter/example:latest'
}

@test "reads tags from toml with csv" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms-tags
  run list-tags.sh -c
  popd
  assert_output '"docker.io/boxcutter/example:1.2.3","docker.io/boxcutter/example:latest"'
}

# @test "reads tags from toml with name and platform" {
#   pushd $PROJECT_ROOT/test/fixture/image-toml-name-platforms
#   run list-tags.sh
#   popd
#   assert_output --partial 'docker.io/boxcutter/example:1.2.3'
#   assert_output --partial 'docker.io/boxcutter/example:latest'
# }

@test "reads tags from toml with name and tags" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-tags
  run list-tags.sh
  popd
  assert_output --partial 'docker.io/boxcutter/example:1.2.3'
  assert_output --partial 'docker.io/boxcutter/example:latest'
}

@test "reads tags from toml with name and tags with plain text" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-tags
  run list-tags.sh -t
  popd
  assert_output --partial 'docker.io/boxcutter/example:1.2.3'
  assert_output --partial 'docker.io/boxcutter/example:latest'
}

@test "reads tags from toml with name and tags with csv" {
  pushd $PROJECT_ROOT/test/fixture/image-toml-name-tags
  run list-tags.sh -c
  popd
  assert_output '"docker.io/boxcutter/example:1.2.3","docker.io/boxcutter/example:latest"'
}
