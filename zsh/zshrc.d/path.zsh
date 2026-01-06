export PATH=$HOME/.jenv/bin:$HOME/.composer/vendor/bin:$HOME/go/bin:$HOME/bin:/opt/homebrew/opt/rustup/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/openjdk/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.deno/bin:$HOME/.local/bin:$PATH

[[ -f $HOME/bin/google-cloud-sdk/path.zsh.inc ]] && source $HOME/bin/google-cloud-sdk/path.zsh.inc
[[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env
[[ -f "$HOME/.op/plugins.sh" ]] && source $HOME/.op/plugins.sh

[[ -n "${ANDROID_HOME}" ]] && export PATH=$PATH:$ANDROID_HOME/emulator:$PATH/platform-tools

[[ -n "${ZPLUG_HOME}" ]] && export PATH=$PATH:${ZPLUG_HOME}/repos/wfxr/forgit/bin
