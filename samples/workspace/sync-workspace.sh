#!/usr/bin/env bash
set -euo pipefail

rsync -avzhe ssh --progress --delete . $1:/workspace
