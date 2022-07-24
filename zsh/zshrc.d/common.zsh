setopt clobber
unsetopt correct

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

has -q zoxide && eval "$(zoxide init zsh)"

[[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"