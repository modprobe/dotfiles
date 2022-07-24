source ~/.zshrc.d/git-aliases.zsh

alias ls="lsd"
alias b="brew"
alias k="kubectl"
alias md="glow"
alias hr="hr —"

alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc'

alias 1p='eval $(op signin alex)'
alias ns="kubens | fzf --no-preview --ansi --height=25% --layout=reverse | xargs kubens"

command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
command -v awsume >/dev/null 2>&1 && alias awsume="source awsume"

function phpswitch() {
	phpswitch.sh $@ -s
}
