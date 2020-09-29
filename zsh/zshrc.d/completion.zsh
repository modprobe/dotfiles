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