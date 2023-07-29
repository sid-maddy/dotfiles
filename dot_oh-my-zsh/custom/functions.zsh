#!/usr/bin/env zsh
fm() {
    local output_file
    output_file="$(mktemp)"

    local exit_code
    env joshuto --output-file "$output_file" $@
    exit_code=$?

    case "$exit_code" in
        # regular exit
        0) ;;
        # output contains current directory
        101)
            cd "$(cat "$output_file")"
            ;;
        # output selected files
        102) ;;
        *)
            echo "Exit code: $exit_code"
            ;;
    esac
}

least() {
    local command
    command=$(printf ' %q' "$@")
    (trap '' SIGINT; eval "${command}") | eval "${PAGER} -b -1 +F"
}
