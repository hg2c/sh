#!/usr/bin/env bash

# https://google.github.io/styleguide/shell.xml

# TODO mv to config.sh
setup:defaults() {
    GLOBAL_INTERACTIVE=${GLOBAL_INTERACTIVE:-0}
    VERBOSE=$(VERBOSE:-false)
    DRYRUN=${DRYRUN:-false}
}

setup() {
    setup:defaults

    local _LIB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source $_LIB/core/lib.sh
    source $_LIB/core/profile.sh
    source $_LIB/core/test.sh
    source $_LIB/core/java.sh
}

setup
