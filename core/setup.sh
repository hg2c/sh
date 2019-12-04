#!/usr/bin/env bash
export _LIB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

setup:defaults() {
    GLOBAL_INTERACTIVE=${GLOBAL_INTERACTIVE:-0}
}

setup() {
    setup:defaults
}

setup

source ../../core/lib.sh
source ../../core/profile.sh
