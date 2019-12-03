#!/usr/bin/env bash

########################################
# The order of use profile
# 1. set profile from file
ACTIVE_PROFILE_FILE=../test/resources/idx

# 2. set profile use env ACTIVE_PROFILE

# 3. default profile
DEFAULT_PROFILE=${ACTIVE_PROFILE:-default}

[[ -f ${ACTIVE_PROFILE_FILE} && -s ${ACTIVE_PROFILE_FILE} ]] && PROFILE=$(cat ${ACTIVE_PROFILE_FILE})

PROFILE=${PROFILE:-${DEFAULT_PROFILE}}
########################################

echo "[INFO] Active Profile = $PROFILE"
