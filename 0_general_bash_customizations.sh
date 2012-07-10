#!/bin/bash
unset HAVE_SOURCED_GENERAL_BASH_CUSTOMIZATIONS
export IGNOREEOF=1
export PS1="\u \w> "
export EDITOR='emacs -nw'

BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bind 'set completion-ignore-case on'
bind '"\eS"':"\"source ~/.bashrc\C-m\"" # alt-S loads source
bind '"\ej"':"\"\eb\"";                 # alt-j moves cursor back word
bind '"\ek"':"\"\ef\""                  # alt-k moves cursor forward word
bind '"\eJ"':"\"\C-w\"";                # alt-J cuts word behind cursor
bind '"\eK"':"\"\ed\""                  # alt-K cuts word in front of cursor
bind '"\e<"':"\"\C-ubind-U\C-m\""           # alt-U same as cd ../
bind '"\e>"':"\"\C-ubind-F\C-m\""
bind '"\eL"':"\"\C-uls-type\C-m\""          # alt-L same as ls
bind '"\e&"':"\"\C-udo-svn\C-m\""
bind '"\eG"':"\"\C-udo-git\C-m\""
bind '"\ew"':kill-region


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lah='ls -lAh'
alias emacs='emacs -nw'
alias irb='irb --simple-prompt'
alias lah='ls -lAh'
alias emacs='emacs -nw'
bind 'set completion-ignore-case on'
set completion-ignore-case on

source $BASH_FILES_DIR/general_functions.sh

HAVE_SOURCED_GENERAL_BASH_CUSTOMIZATIONS=1