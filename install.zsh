#!/usr/bin/env bash
# shellcheck shell=bash

set -e

if [ ! "$(command -v chezmoi)" ]; then
    bin_dir="${HOME}/.local/bin"
    chezmoi="${bin_dir}/chezmoi"

    if [ "$(command -v curl)" ]; then
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "${bin_dir}"
    elif [ "$(command -v wget)" ]; then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "${bin_dir}"
    else
        echo >&2 "To install chezmoi, you must have curl or wget installed."
        exit 1
    fi
else
    chezmoi=chezmoi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

exec "${chezmoi}" init --apply --source="${script_dir}"
