#!/usr/bin/env bash
fn:mock() {
    local NAME=$1
    local BODY=$(cat <<-END
$NAME() {
    echo $NAME
}
END
         )
    eval "$BODY"
}
