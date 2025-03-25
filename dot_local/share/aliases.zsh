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

alias gt='gitui'
alias lg='lazygit'

# NeoVim
alias vimdiff='nvim -d'

# Poetry
alias prun='poetry run'
alias pred="poetry run ${EDITOR}"
alias pot='poetry task'
alias prt='poetry run task'

# UV
alias uvrun='uv run'
alias uvred="uv run ${EDITOR}"
