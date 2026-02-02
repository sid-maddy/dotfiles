#!/usr/bin/env zsh
# Alts
alias cat='bat -pp'
alias lesser='bat -p'
alias ping='prettyping --nolegend'

# Git
alias gbv='git branch -vv'
alias gf='git fetch -f'
alias gl='git pull -f'
alias gmm='git merge $(git_main_branch)'

# NeoVim
alias vimdiff='nvim -d'

# UV
alias uvrun='uv run'
alias uvred="uv run ${EDITOR}"
