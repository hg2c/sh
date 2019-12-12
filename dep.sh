#!/usr/bin/env bash

export SH_MODULES="java osx"

DEP_MODE=${DEP_MODE:-}
DEP_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DEP_LOCK=${DEP_HOME}/.dep.lock
# NOTICE: No newline at end of file DEP_LOCK will break dep funcs
DEP_VENDOR=${DEP_HOME}/vendor

readonly DEP_HOME
readonly DEP_LOCK
readonly DEP_VENDOR


list:foreach() {
    local list=$1
    local func=${2:-echo}

    [ ! -z "$list" ] && while IFS= read -r line; do
        $func "$line"
    done << EOF
$list
EOF
}

dep:parse() {
    local line=$1
    local pkg=$(echo $line | cut -d '=' -f 1)
    local ver=${line#$pkg=}
    printf '%s|%s|%s\n' "$line" "$pkg" "$ver"
}

dep:config:packages() {
    if [ -s ${DEP_LOCK} ]; then
        cat ${DEP_LOCK}
    fi
}

dep:foreach() {
    list:foreach "$(dep:config:packages)" dep:parse
}

dep:package:path() {
    : ${1:?"pkg is required"}

    if [ "${DEP_MODE}" = "file" ]; then
        echo ~/.dep.sh/cache/$pkg
    else
        echo ${DEP_VENDOR}/$pkg
    fi
}

dep:package:setup() {
    local pkg=$1
    local packagedFile=${DEP_HOME}/.dep.vendor.sh

    echo -e "# Auto generate by dep.sh\n" > $packagedFile
    for file in $pkg/lib/*.sh ; do
        sed /^#.*/d $file >> $packagedFile
        echo "pack $file to $packagedFile"
    done
}


dep:install() {
    dep:foreach install
}

dep:import() {
    dep:foreach import
}

dep:update() {
    dep:foreach update
}



dep:install:line() {
    : ${1:?"pkg is required"}
    : ${2:?"ver is required"}

    local pkg=$1
    local ver=$2
    local path=$(dep:package:path $pkg)
    local cmd="git clone $ver $path"
    echo $cmd
    if [ ! -d "$path" ]; then
        echo "$pkg installing... ($cmd)"
        $cmd
    else
        echo "$pkg exists, skip."
    fi
}

dep:import:line() {
    local path=$(dep:package:path $1)
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        echo "$path not exists, skip."
    fi
}

dep:update:line() {
    local path=$(dep:package:path $1)
    if [ -d "$path" ]; then
        echo "$path updating..."
        git -C $path pull

        dep:package:setup $path
    else
        echo "$path not exists, skip."
    fi
}

case ${1:-} in
    i|install)
        dep:install
        ;;

    u|update)
        dep:update
        ;;

    *)
        dep:import
        ;;
esac
