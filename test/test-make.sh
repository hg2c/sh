#!/usr/bin/env bash
set -euo pipefail

source ./index.sh

fn:mock foo
fn:mock bar
fn:mock zoo

all() {
    echo all
    fn:run foo bar zoo
}

fn:run $*
