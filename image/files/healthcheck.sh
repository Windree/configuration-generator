#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s inherit_errexit

declare healthcheck_file="/run/status"

[ -f "$healthcheck_file" ] && exit 0 || exit 1
