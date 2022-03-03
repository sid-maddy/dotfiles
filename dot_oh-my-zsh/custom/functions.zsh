#!/usr/bin/env zsh
least()  {
    local command
    command=$(printf ' %q' "$@")
    (trap '' SIGINT; eval "${command}") | eval "${PAGER} -b -1 +F"
}
