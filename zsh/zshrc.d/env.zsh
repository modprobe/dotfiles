export EDITOR="vim"
export BROWSER="open"
export PAGER="less"
export DEFAULT_USER="alex"
export LESS="--mouse -r"

export FZF_DEFAULT_OPTS='--color=dark --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7'

export SAM_CLI_TELEMETRY=0

defaults read -g AppleInterfaceStyle >/dev/null 2>&1 && export BAT_THEME="Dracula Pro" || export BAT_THEME="Alucard"
export HAS_ALLOW_UNSAFE="y"

export ANDROID_HOME=$HOME/Library/Android/sdk

has -q fnm && eval "$(fnm env --use-on-cd)"
has -q awsume && alias awsume="source awsume"

[[ -s "$(brew --prefix)/etc/profile.d/z.sh" ]] && source $(brew --prefix)/etc/profile.d/z.sh

export NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/eon-ca.crt"
