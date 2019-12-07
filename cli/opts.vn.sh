#!/usr/bin/env bash

VERBOSE='false'
DRYRUN='false'

while getopts ":vn" flag
do
    case $flag in
        v) VERBOSE=true ;;
        n) DRYRUN=true ;;
        ?) echo "error opts" && exit 1 ;;
    esac
done
shift $(( $OPTIND-1 ))

readonly VERBOSE
readonly DRYRUN
