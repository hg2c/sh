#!/usr/bin/env bash
set -euo pipefail

logger:info() {
    echo $1
    echo $2
}

FOO="-rnv --exclude='.*'"
logger:info $FOO
set -- $FOO
logger:info $@
