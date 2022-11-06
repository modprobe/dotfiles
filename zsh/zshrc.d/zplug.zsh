if has -q homebrew && [[ -f "$(brew --prefix)/opt/zplug/init.zsh" ]]
then
    export ZPLUG_HOME="$(brew --prefix)/opt/zplug"
    source $ZPLUG_HOME/init.zsh
fi

# https://github.com/wfxr/forgit
export FORGIT_NO_ALIASES=1
export FORGIT_LOG_FZF_OPTS='--reverse'
zplug 'wfxr/forgit'

export NVM_LAZY_LOAD=true
zplug "lukechilds/zsh-nvm"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load