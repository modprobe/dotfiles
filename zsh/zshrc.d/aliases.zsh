source ~/.zshrc.d/git-aliases.zsh
alias helium='open -a Helium --args --remote-debugging-port=9222'

alias ls="lsd"
alias b="brew"
alias k="kubectl"
alias md="glow"
alias hr="hr —"

alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc'

alias 1p='eval $(op signin alex)'
# alias ns="kubens | fzf --no-preview --ansi --height=25% --layout=reverse | xargs kubens"
alias ns='FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --height=25% --layout=reverse" kubens'

command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
command -v awsume >/dev/null 2>&1 && alias awsume="source awsume"

function phpswitch() {
	phpswitch.sh $@ -s
}

if [[ -z "$AWS_PROFILE" ]]
then
  export AWS_PROFILE=messaging-dev
fi

aws_profile () {
    prof=$(aws configure list-profiles | fzf --history=${HOME}/.cache/aws_profiles --reverse --height=10)

    if [[ -z "$prof" ]]
    then
        unset AWS_PROFILE
        return 1
    fi

    export AWS_PROFILE=$prof

    aws sts get-caller-identity --profile=$prof &>/dev/null
    IS_LOGGED_OUT="$?"
    if [[ "$IS_LOGGED_OUT" -eq "255" ]]; then
        aws sso login --profile=$prof
    fi
}

alias ap=aws_profile
