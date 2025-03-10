#!/usr/bin/env zsh
export LESS='-fiFMRS -# 1 --follow-name --no-histdups'
export SKIM_DEFAULT_OPTIONS='--reverse'

# cURL
export CURL_CA_BUNDLE="${HOME}/.local/share/ca-bundle.crt"

# Docker Compose
export COMPOSE_BAKE=true

# Homebrew
export HOMEBREW_BAT=1
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=1
export HOMEBREW_CURLRC=1
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_COMPAT=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_UPDATE_TO_TAG=1

# Google Cloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# JJ
export JJ_CONFIG="${HOME}/.config/jj/config.toml"

# k9s
export K9S_CONFIG_DIR="${HOME}/.config/k9s"

# Starship
export STARSHIP_LOG=error

[ -f "${HOME}/.local/share/exports.local.zsh" ] && source "${HOME}/.local/share/exports.local.zsh"
