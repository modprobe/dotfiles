alias gct="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gctm="gct master..HEAD"

alias grbm="git stash && git fetch --all && git rebase origin/master && git stash pop"

alias gst="git status"
alias gcm="git checkout master"
alias gcmsg="git commit --message"
alias gca="git commit --amend"
alias gca!="git commit --amend --reuse-message HEAD"
alias gl="git pull --rebase --autostash"
alias glg='git log --topo-order --pretty=format:"${_git_log_medium_format}"'

fzflog () {
  git log $1 --color=always --graph \
    --pretty=format:'%Cred%h%Creset %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit \
    | head -5000 \
    | fzf --ansi +s --height 40 --reverse \
    --preview 'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
    --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
      (grep -o '[a-f0-9]\{7\}' | head -1 |
      xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      {}
	FZF-EOF"
}