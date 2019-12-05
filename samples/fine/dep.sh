#!/usr/bin/env bash
dep:install() {
    echo install
    mkdir -p vendor

    line=$(cat .dep.lock)
    dep:install:line $line

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

case ${1:-} in
    i|install)
        dep:install
        ;;

    u|update)
        echo update
        ;;

    *)
        echo import
        MODULE="java profile" source ../../index.sh

        ;;
esac
