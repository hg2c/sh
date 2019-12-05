#!/usr/bin/env bash
# NOTICE: No newline at end of file DEP_LOCKFILE will break dep funcs
DEP_LOCKFILE=.dep.lock

dep:foreach() {
    if [ -s ${DEP_LOCKFILE} ]; then
        while IFS= read -r line; do
            local pkg=$(echo $line | cut -d '=' -f 1)
            local ver=${line#$pkg=}

            dep:$1:line "$pkg" "$ver" "$line"
        done < ${DEP_LOCKFILE}
    fi
}

dep:install() {
    mkdir -p vendor
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
    local path=./vendor/$pkg
    local cmd="git clone $ver $path"
    if [ ! -d "$path" ]; then
        echo "$pkg installing... ($cmd)"
        $cmd
    else
        echo "$pkg exists, skip."
    fi
}

dep:import:line() {
    local pkg=$1
    local path=./vendor/$pkg
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        echo "$path not exists, skip."
    fi
}

dep:update:line() {
    local path=./vendor/$1
    if [ -d "$path" ]; then
        echo "$path updating..."
        git -C $path pull
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
