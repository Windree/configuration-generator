#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s inherit_errexit

declare -a watch_items=()
declare format=
declare template=
declare input_file=
declare output_file=

function parse_command() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --*)
                case "$1" in
                    --watch)
                        if [ ! -v 2 ] || [ -z "$2" ]; then
                            return 1
                        fi
                        watch_items+=("$2")
                        shift 2
                        continue
                    ;;
                    --format)
                        if [ ! -v 2 ] || [ -z "$2" ]; then
                            return 1
                        fi
                        format="$2"
                        shift 2
                        continue
                    ;;
                esac
            ;;
            *)
                if [ -n "$1" ] && [ -z "$template" ]; then
                    template="$1"
                    shift
                    continue
                fi
                if [ -n "$1" ] && [ -z "$input_file" ]; then
                    input_file="$1"
                    shift
                    continue
                fi
                if [ -n "$1" ] && [ -z "$output_file" ]; then
                    output_file="$1"
                    shift
                    continue
                fi
                return 1
            ;;
        esac
    done
    [ -n "$template" ] && [ -n "$input_file" ] && [ -n "$output_file" ] || return 1
}

function validate_all() {
    local error=false
    validate_template || error=true
    validate_input_file || error=true
    validate_output_file || error=true
    validate_watch || error=true
    $error && return 1 || return 0
}

function validate_watch() {
    local error=false
    for item in "${watch_items[@]}"; do
        if [ ! -e "$item" ]; then
            if ! $error; then   
                print_usage
            fi
            echo "--watch '$item'. The watch location not found."
            error=true
        fi
    done
    $error && return 1 || return 0
}

function validate_template() {
    if [ ! -f "$template" ]; then
        print_usage
        echo "<template> '$template'. The file not found."
        return 1
    fi
}

function validate_input_file() {
    if [ ! -f "$input_file" ]; then
        print_usage
        echo "<input file> '$input_file'. The file not found."
        return 1
    fi
}

function validate_output_file() {
    local folder="$(dirname "$output_file")"
    if [ ! -d "$folder" ]; then
        print_usage
        echo "<output file> '$output_file'. The file's folder '$folder' not found."
        return 1
    fi
}

function main() {
    local j2_args=()
    local watch_count=${#watch_items[@]}
    local inotifywait_output=
    [ -n "$format" ] && j2_args+=("--format" "$format")
    while true; do
        if [ ! -f "$input_file" ]; then
            rm -f "$output_file"
        else
            jinja2 "${j2_args[@]}" --outfile "$output_file" "$template" "$input_file"
        fi
        
        [ $watch_count -eq 0 ] && break
        
        inotifywait_output="$(inotifywait -r -e modify -e create -e delete -e moved_to "${watch_items}" 2> /dev/null)"
        echo "Changes detected:"
        echo "$inotifywait_output"
    done
}

function print_usage(){
    echo "Usage: [--watch <location>]... [--format <type>] <template> <input file> <output file>"
}

function stop() {
    pkill inotifywait
}

trap stop EXIT

if ! parse_command "$@"; then
    
    exit 1
fi

if ! validate_all; then
    exit 2
fi

main
