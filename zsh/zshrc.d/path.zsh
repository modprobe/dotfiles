export PATH=$HOME/.composer/vendor/bin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

[[ -f $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]] && source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

[[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env
