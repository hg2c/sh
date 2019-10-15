#!/usr/bin/env bash
set -euo pipefail

source ./core/lib.sh
source ./core/test.sh

foo() {
    echo $1
    echo $2
}


foo "-Xms -Xmx" ok.

logger:run foo \"-Xms -Xmx\" ok.
