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


mod_install() {
    mod_each download
    mod_pack
}

mod_update() {
    mod_each update
    mod_pack
}

mod_pack() {
    if [ "${MOD_TYPE}" = "file" ]; then
        echo -e "# Auto generate by dep.sh\n" > $MOD_VENDOR_FILE
    fi

    mod_each pack
}


mod_import() {
    if [ "${MOD_TYPE}" = "file" ]; then
        source $MOD_VENDOR_FILE
    else
        mod_each import
    fi
}


mod_err() {
    >&2 echo "$@"
    exit 2
}

mod_check_def() {
    if [ ! -s ${MOD_DEF} ]; then
        mod_err "warn: $MOD_DEF not exist."
    fi
}

mod_each() {
    while IFS= read -r line; do
        local name=$(echo $line | cut -d '=' -f 1)
        local repo=${line#$name=}
        mod_$1_package "$name" "$repo" "$line"
    done < ${MOD_DEF}
}

mod_download_package() {
    local name=$1
    local repo=$2
    local path=$MOD_VENDOR/$name
    local cmd="git clone $repo $path"
    if [ ! -d "$path" ]; then
        echo "$name installing... ($cmd)"
        $cmd
    else
        mod_err "$name exists, skip."
    fi
}

mod_update_package() {
    local path=$MOD_VENDOR/$1
    if [ -d "$path" ]; then
        echo "$path updating..."
        cd $path && git pull
    else
        mod_err "$path not exists, skip."
    fi
}

mod_pack_package() {
    local lib=$MOD_VENDOR/$1/lib
    for file in $lib/*.sh ; do
        sed /^#.*/d $file >> $MOD_VENDOR_FILE
        echo "pack $file to $MOD_VENDOR_FILE"
    done
}

mod_import_package() {
    local path=$(dep::package::path $1)
    if [ -d "$path" ]; then
        source $path/index.sh
    else
        mod_err "$path not exists, skip."
    fi
}


mod_check_def

case ${1:-} in
    i|install)
        mod_install
        ;;

    u|update)
        mod_update
        ;;

    *)
        mod_import
        ;;
esac
