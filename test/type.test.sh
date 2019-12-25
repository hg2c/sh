#!/usr/bin/env bash
set -euo pipefail

source ./lib/type.sh

multiline1=$(cat <<-END
    This is line one.
    This is line two.
    This is line three.
END
)

multiline2="
    This is line one.
    This is line two.
    This is line three.
"

NO=0
test:each() {
    NO=$((NO + 1))
    echo "$NO|$1"
}

list:each "$(cat <<-END
01.pilosa.local
02.pilosa.local
03.pilosa.local
END
)"

list:each "a
b
c" test:each

list:each "$multiline1"
list:each "$multiline2" test:each
list:each "$(ls)"

list:first "$multiline1"
