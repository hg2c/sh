#!/usr/bin/env bash
set -euo pipefail

source ./core/lib.sh
source ./core/test.sh

echo lib.sh: $SSD

import:sh foo.sh
assert:notEmpty FOO

fn:mock foo
fn:mock bar
fn:mock zoo

all() {
    echo $1
    fn:run foo bar zoo
}

logger:run foo

fn:run $*
