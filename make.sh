#!/usr/bin/env bash
set -euo pipefail

SSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

fn:mock() {
    local NAME=$1
    local BODY=$(cat <<-END
$NAME() {
    echo $NAME
}
END
         )
    eval "$BODY"
}

fn:mock foo
fn:mock bar
fn:mock zoo

all() {
    fn:run foo bar zoo
}

fn:run() {
    for cmd in $*; do
        echo [MAKE] call $cmd...
        $cmd
    done
}

fn:run $*
