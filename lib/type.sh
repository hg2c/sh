#!/usr/bin/env bash

list:each() {
    local list=$1
    local func=${2:-echo}

    [ ! -z "$list" ] && while IFS= read -r line; do
        $func "$line"
    done << EOF
$list
EOF
}

list:first() {
    head -1 <<EOF
$1
EOF
}
