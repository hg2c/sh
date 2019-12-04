#!/usr/bin/env bash
set -euo pipefail

GLOBAL_INTERACTIVE=1
ACTIVE_PROFILE_FILE=../profile
DEFAULT_PROFILE=3


MODULE="java profile" source ../../core/setup.sh
assert:notEmpty _LIB

SSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

assert:notEmpty SSD
