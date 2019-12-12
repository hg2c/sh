#!/usr/bin/env bash
source ./dep.sh

# dep::install::line
var=0

test:each() {
    let "var++"
    printf '%s\n' "$var|$1"
}

test:each:info() {
    var=0
    echo ===================
}


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

list:foreach "$multiline1" test:each
test:each:info
# assertEqual $var 3

list:foreach "$multiline2" test:each
test:each:info
# assertEqual $var 5

list:foreach "$(cat INBOX.md)" test:each
test:each:info
# assertEqual $var 2

list:foreach "" test:each
test:each:info

list:foreach "$(ls)" test:each

dep:foreach
