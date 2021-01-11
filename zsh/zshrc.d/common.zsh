export EDITOR="vim"
export BROWSER="open"
export PAGER="less"
export DEFAULT_USER="alex"

setopt clobber
unsetopt correct

alias ls="lsd"
alias b="brew"
alias k="kubectl"

alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc'

export PATH="$HOME/go/bin:$PATH"

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
br () {
    f=$(mktemp)
    (
	set +e
	broot --outcmd "$f" "$@"
	code=$?
	if [ "$code" != 0 ]; then
	    rm -f "$f"
	    exit "$code"
	fi
    )
    code=$?
    if [ "$code" != 0 ]; then
	return "$code"
    fi
    d=$(<"$f")
    rm -f "$f"
    eval "$d"
}

src () {
	local cache="${ZSH_CACHE_DIR:-$HOME/.cache}"
	autoload -U compinit zrecompile
	compinit -i -d "$cache/zcomp-$HOST"
	for f in ~/.zshrc "$cache/zcomp-$HOST"
	do
		zrecompile -p $f && command rm -f $f.zwc.old
	done
	[[ -n "$SHELL" ]] && exec ${SHELL#-} || exec zsh
}

[[ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ]] && source "/usr/local/opt/fzf/shell/key-bindings.zsh"
[[ -f "/usr/local/opt/fzf/shell/completion.zsh" ]] && source "/usr/local/opt/fzf/shell/completion.zsh"

export SAM_CLI_TELEMETRY=0
