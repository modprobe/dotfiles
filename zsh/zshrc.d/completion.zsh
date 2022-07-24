unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache

zstyle ':completion:*' completer _complete _match 
zstyle ':completion:*:match:*' original only

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' group no
zstyle ':completion:*' group-name ''

if whence -p aws_completer &>/dev/null
then
    autoload bashcompinit
    bashcompinit

    complete -C $(whence -p aws_completer) aws
fi

[[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
[[ -f $HOME/bin/google-cloud-sdk/completion.zsh.inc ]] && source $HOME/bin/google-cloud-sdk/completion.zsh.inc

if type brew &>/dev/null && [[ -d "$(brew --prefix)/share/zsh-completions" ]]
then
  fpath=($(brew --prefix)/share/zsh-completions $(brew --prefix)/share/zsh/site-functions $fpath)
fi

command -v minikube >/dev/null 2>&1 && source <(minikube completion zsh)
command -v argocd >/dev/null 2>&1   && source <(argocd completion zsh)
command -v kubectl >/dev/null 2>&1  && source <(kubectl completion zsh)  

[[ -d ~/.awsume/zsh-autocomplete  ]] && fpath=(~/.awsume/zsh-autocomplete $fpath)

compinit -u


_gita_completions()
{

  local cur commands repos cmd
  local COMP_CWORD COMP_WORDS
  read -cn COMP_CWORD
  read -Ac COMP_WORDS

  cur=${COMP_WORDS[COMP_CWORD]}
  cmd=${COMP_WORDS[2]}

  commands=`gita -h | sed '2q;d' |sed 's/[{}.,]/ /g'`

  repos=`gita ls`

  if [ -z "$cmd" ]; then
    reply=($(compgen -W "${commands}" ${cur}))
  else
    cmd_reply=($(compgen -W "${commands}" ${cmd}))
    case $cmd in
      add)
        reply=(cmd_reply $(compgen -d ${cur}))
        ;;
      ll)
        return
        ;;
      *)
        reply=($cmd_reply $(compgen -W "${repos}" ${cur}))
        ;;
    esac
  fi

}

compctl -K _gita_completions gita
