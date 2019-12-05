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
    echo $1
    fn:run foo bar zoo
}

fn:run() {
    for cmd in $*; do
        echo [MAKE] call $cmd...
        $cmd
    done
}

fn:run $*

all 1

JAVA=${JAVA:-}

echo "1${JAVA}1"



__usage="
Usage: $(basename $0) [OPTIONS]

Options:
  -l, --level <n>              Something something something level
  -n, --nnnnn <levels>         Something something something n
  -h, --help                   Something something something help
  -v, --version                Something something something version
"

echo "$__usage"
