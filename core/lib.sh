#!/usr/bin/env bash
export SSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

assert:notEmpty() {
    local var=$(eval echo \$$1)
    if [ -z "$var" ]; then
        echo "FAIL: $1 does not defined, or is empty"
        exit 127
    else
        echo "ECHO: $1=$var"
    fi
}

logger:run() {
    echo "[RUN] $*" && eval "$*"
    return_value=$?
    if [ "$return_value" != "0" ]; then
        echo "FAIL: \"$*\" STOPPED WITH EXIT CODE $return_value."
        exit 127
    fi
}

import:sh() {
    local file=$1
    if [ -s "$file" ]; then
        source $file
    else
        echo "FAIL: file $file does not exist, or is empty"
        exit 127
    fi
}

fn:run() {
    for cmd in $*; do
        echo [MAKE] call $cmd...
        $cmd
    done
}
