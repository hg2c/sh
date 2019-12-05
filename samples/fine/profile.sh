#!/usr/bin/env bash
set -euo pipefail

GLOBAL_INTERACTIVE=1
ACTIVE_PROFILE_FILE=../profile
DEFAULT_PROFILE=3

source ./dep.sh

SSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
assert:notEmpty SSD
