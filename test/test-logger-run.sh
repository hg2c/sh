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
logger:run /opt/findbugs-3.0.1/bin/findbugs -jvmArgs \"-Xms128m -Xmx2048m\" -home /opt/findbugs-3.0.1 \
           -textui -effort:max -sortByClass -html -output findbug-result.html \
           ~/Entropy/lotreal/findbugs-demo/build/classes
