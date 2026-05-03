#!/usr/bin/env bash
set -Eeuxo pipefail
shopt -s inherit_errexit

declare healthcheck_file="/run/status"

[ -f "$healthcheck_file" ] && exit 0 || exit 1
