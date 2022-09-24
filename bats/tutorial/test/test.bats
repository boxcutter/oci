setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown() {
    rm -f /tmp/bats-tutorial-project-ran
}

@test "Show welcome message on first invocation" {
    if [[ -e /tmp/bats-tutorial-project-ran ]]; then
        skip 'The FIRST_RUN_FILE already exists'
    fi

    run project.sh
    assert_output --partial 'Welcome to our project!'

    run project.sh
    refute_output --partial 'Welcome to our project!'
}
