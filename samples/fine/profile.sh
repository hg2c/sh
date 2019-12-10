#!/usr/bin/env bash
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -euo pipefail

source ./config.sh
source ./dep.sh

SSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
assert:notEmpty SSD


__usage="
Usage: $(basename $0) [OPTIONS]

Options:
  -l, --level <n>              Something something something level
  -n, --nnnnn <levels>         Something something something n
  -h, --help                   Something something something help
  -v, --version                Something something something version
"

echo "$__usage"
