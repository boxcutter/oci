#!/usr/bin/env bash

_is_first_run() {
    local FIRST_RUN_FILE=/tmp/bats-tutorial-project-ran
    if [[ ! -e "$FIRST_RUN_FILE" ]]; then
        touch "$FIRST_RUN_FILE"
        return 0
    fi
    return 1
}
