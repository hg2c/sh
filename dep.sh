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

mod_check_def() {
    [ ! -s ${MOD_DEF} ] && \
        mod_err "warn: $MOD_DEF not exist."
}

mod_download() {
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


dep::foreach() {
    mod_check_def
    while IFS= read -r line; do
        local pkg=$(echo $line | cut -d '=' -f 1)
        local ver=${line#$pkg=}

        dep::$1::line "$pkg" "$ver" "$line"
    done < ${MOD_DEF}
}

dep::package::setup() {
    local pkg=$1
    local packagedFile=${MOD_HOME}/.dep.vendor.sh

    echo -e "# Auto generate by dep.sh\n" > $packagedFile
}

dep::install() {
    if [ "${MOD_TYPE}" = "file" ]; then
        echo -e "# Auto generate by dep.sh\n" > $MOD_VENDOR_FILE
    fi

    dep::foreach install
}

dep::import() {
    if [ "${MOD_TYPE}" = "file" ]; then
        echo source $MOD_VENDOR_FILE
        source $MOD_VENDOR_FILE
    else
        dep::foreach import
    fi
}

dep::update() {
    dep::foreach update
}

dep::install::line() {
    mod_download $1 $2

    if [ "${MOD_TYPE}" = "file" ]; then
        local lib=$MOD_VENDOR/$1/lib
        for file in $lib/*.sh ; do
            sed /^#.*/d $file >> $MOD_VENDOR_FILE
            echo "pack $file to $MOD_VENDOR_FILE"
        done
    fi
}

dep::import::line() {
    local path=$(dep::package::path $1)
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        echo "$path not exists, skip."
    fi
}

dep::update::line() {
    local path=$(dep::package::path $1)
    if [ -d "$path" ]; then
        echo "$path updating..."
        # git -C $path pull

        dep::package::setup $path
    else
        echo "$path not exists, skip."
    fi
}

case ${1:-} in
    i|install)
        dep::install
        ;;

    u|update)
        dep::update
        ;;

    *)
        dep::import
        ;;
esac
