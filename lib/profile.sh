#!/usr/bin/env bash

########################################
# The order of use profile
#   1. set profile from file
#   2. set profile use env ACTIVE_PROFILE
#   3. default profile
ACTIVE_PROFILE=${ACTIVE_PROFILE:-${DEFAULT_PROFILE:-""}}

if [ -n "${ACTIVE_PROFILE_FILE:-}" ]; then
    if [[ ! -f ${ACTIVE_PROFILE_FILE} && ${GLOBAL_INTERACTIVE} = 1 ]]; then
        echo "valid value: (1-5,default)"
        echo "default value: dafult"
        read -p "> "
        echo ${REPLY:-${ACTIVE_PROFILE}} > ${ACTIVE_PROFILE_FILE}
    fi

    [[ -f ${ACTIVE_PROFILE_FILE} && -s ${ACTIVE_PROFILE_FILE} ]] && PROFILE=$(cat ${ACTIVE_PROFILE_FILE})
fi

PROFILE=${PROFILE:-${ACTIVE_PROFILE}}
########################################

echo "[INFO] Active Profile = $PROFILE"
