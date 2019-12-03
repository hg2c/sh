#!/usr/bin/env bash

GLOBAL_INTERACTIVE=1

DEFAULT_PROFILE=default
ACTIVE_PROFILE_FILE=../test/resources/idx1

########################################
# The order of use profile
#   1. set profile from file
#   2. set profile use env ACTIVE_PROFILE
#   3. default profile
ACTIVE_PROFILE=${ACTIVE_PROFILE:-${DEFAULT_PROFILE}}

if [[ ! -f ${ACTIVE_PROFILE_FILE} && ${GLOBAL_INTERACTIVE} = 1 ]]; then
    echo "valid value: (1-5,default)"
    echo "default value: dafult"
    read -p "> "
    echo ${REPLY:-${ACTIVE_PROFILE}}
fi

[[ -f ${ACTIVE_PROFILE_FILE} && -s ${ACTIVE_PROFILE_FILE} ]] && PROFILE=$(cat ${ACTIVE_PROFILE_FILE})


PROFILE=${PROFILE:-${ACTIVE_PROFILE}}
########################################

echo "[INFO] Active Profile = $PROFILE"


__usage="
Usage: $(basename $0) [OPTIONS]

Options:
  -l, --level <n>              Something something something level
  -n, --nnnnn <levels>         Something something something n
  -h, --help                   Something something something help
  -v, --version                Something something something version
"

echo "$__usage"
