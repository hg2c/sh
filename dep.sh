#!/usr/bin/env bash
MOD_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOD_DEF=${MOD_HOME}/sh.mod
MOD_TYPE=${MOD_TYPE:-file}
MOD_VENDOR_FILE=${MOD_HOME}/mod.vendor.sh

if [ "${MOD_TYPE}" = "file" ]; then
    MOD_VENDOR=~/.mod.sh/cache
else
    MOD_VENDOR=${MOD_HOME}/vendor
fi

mod_err() {
    >&2 echo "$@"
    exit 2
}

each:package() {
    each:line "$(dep:config:packages)" dep:$1
}

dep:parse() {
    local line=$1
    local pkg=$(echo $line | cut -d '=' -f 1)
    local ver=${line#$pkg=}
    printf '%s|%s|%s\n' "$line" "$pkg" "$ver"

mod_check_def() {
    [ ! -s ${MOD_DEF} ] && \
        mod_err "warn: $MOD_DEF not exist."
}

dep::download::line() {
    local pkg=$1
    local repo=$2
    local path=$MOD_VENDOR/$pkg
    local cmd="git clone $repo $path"
    echo $cmd
    if [ ! -d "$path" ]; then
        echo "$pkg installing... ($cmd)"
        $cmd
    else
        echo "$pkg exists, skip."
    fi
}

dep:foreach() {
    each:package import
    # each:line "$(dep:config:packages)" dep:parse
}

dep::foreach() {
    while IFS= read -r line; do
        local pkg=$(echo $line | cut -d '=' -f 1)
        local ver=${line#$pkg=}

        local pkg="$1"
    echo "okg $pkg"

    if [ "${DEP_MODE}" = "file" ]; then
        echo ~/.dep.sh/cache/$pkg
    else
        echo ${DEP_VENDOR}/$pkg
    fi

        dep::$1::line "$pkg" "$ver" "$line"
    done < ${MOD_DEF}

}

dep::install() {
    if [ "${MOD_TYPE}" = "file" ]; then
        echo -e "# Auto generate by dep.sh\n" > $MOD_VENDOR_FILE
    fi

    dep::foreach download
    dep::foreach pack
}

dep::import() {
    if [ "${MOD_TYPE}" = "file" ]; then
        echo source $MOD_VENDOR_FILE
        source $MOD_VENDOR_FILE
    else
        dep::foreach import
    fi
}


dep:update() {
    dep:foreach update

dep::update() {
    dep::foreach update
    dep::foreach pack
}

dep::install::line() {
    mod_download $1 $2
}

dep::pack::line() {
    local lib=$MOD_VENDOR/$1/lib
    for file in $lib/*.sh ; do
        sed /^#.*/d $file >> $MOD_VENDOR_FILE
        echo "pack $file to $MOD_VENDOR_FILE"
    done
}


dep:import() {
    echo 1
    echo $*
    local path=$(dep:package:path $1)

dep::import::line() {
    local path=$(dep::package::path $1)
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        echo "$path not exists, skip."
    fi

}

dep::update::line() {
    local path=$MOD_VENDOR/$1
    if [ -d "$path" ]; then
        echo "$path updating..."
        cd $path && git pull
    else
        echo "$path not exists, skip."
    fi
}

mod_check_def

case ${1:-} in
    i|install)
        dep::install
        ;;

    u|update)
        dep::update
        ;;

    *)

        each:package import

        dep::import

        ;;
esac
