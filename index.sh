#!/usr/bin/env bash
setup:defaults() {
    GLOBAL_INTERACTIVE=${GLOBAL_INTERACTIVE:-0}
}

setup() {
    setup:defaults

    local _LIB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source $_LIB/core/lib.sh
    source $_LIB/core/profile.sh
    source $_LIB/core/test.sh
}

setup
