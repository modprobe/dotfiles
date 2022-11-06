export PATH=$HOME/.jenv/bin:$HOME/.composer/vendor/bin:$HOME/go/bin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/openjdk/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH

[[ -f $HOME/bin/google-cloud-sdk/path.zsh.inc ]] && source $HOME/bin/google-cloud-sdk/path.zsh.inc
[[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env
