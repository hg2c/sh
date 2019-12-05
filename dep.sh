#!/usr/bin/env bash
# NOTICE: No newline at end of file DEP_LOCKFILE will break dep funcs
DEP_LOCKFILE=.dep.lock

dep:install() {
    mkdir -p vendor

    while IFS= read -r line; do
        echo install $line
        dep:install:line $line
    done < ${DEP_LOCKFILE}
}

dep:install:line() {
    local line=$*
    local pkg=$(echo $line | cut -d '=' -f 1)
    local ver=${line#$pkg=}
    local path=./vendor/$pkg
    local cmd="git clone $ver $path"
    if [ ! -d "$path" ]; then
        echo "$pkg installing... ($cmd)"
        $cmd
    else
        echo "$pkg exists, skip."
    fi
}

dep:import() {
    while IFS= read -r line; do
        echo import $line
        dep:import:line $line
    done < ${DEP_LOCKFILE}
}

dep:import:line() {
    local line=$*
    local pkg=$(echo $line | cut -d '=' -f 1)
    local path=./vendor/$pkg
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        echo "$path not exists, skip."
    fi
}


case ${1:-} in
    i|install)
        dep:install
        ;;

    u|update)
        echo TODO update
        ;;

    *)
        dep:import
        ;;
esac
