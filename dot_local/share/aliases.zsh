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

# Kubectl
alias kdelhpa='kubectl delete hpa'
alias kdhpa='kubectl describe hpa'
alias kehpa='kubectl edit hpa'
alias kghpa='kubectl get hpa'
alias kghpaa='kghpa --all-namespaces'
alias kghpaw='kghpa --watch'

# NeoVim
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'

# Poetry
alias prun='poetry run'
alias pred="poetry run ${EDITOR}"
alias pot='poetry task'
alias prt='poetry run task'
