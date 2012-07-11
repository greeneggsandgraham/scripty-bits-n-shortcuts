#!/bin/bash

# BASH_FILES_DIR will be equal to the dir holding this file
BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

unset HAVE_SOURCED_GENERAL_BASH_CUSTOMIZATIONS
set completion-ignore-case on

# xports
export IGNOREEOF=1
export PS1="\u \w> "
export EDITOR='emacs -nw'

# binds
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
bind 'set completion-ignore-case on'

# aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias lah='ls -lAh'
alias emacs='emacs -nw'
alias irb='irb --simple-prompt'
alias lah='ls -lAh'
alias emacs='emacs -nw'
alias rm='rm -i'
alias df='df -h'
alias du='du -sh'
alias h='history | tail'

# sources
source $BASH_FILES_DIR/general_functions.sh

# THUMB BALL MOUSE ES 2 FASTO! SLOW IT DOWN
logitech=$(xinput --list --short | grep -m1 "Logitech" | cut -f2 | cut -d= -f2) # mouse ID
xinput --set-prop "$logitech" "Device Accel Constant Deceleration" 2 # It defaults to 1

# History cusomizations
HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history.
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000     # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=2000 # ""

HAVE_SOURCED_GENERAL_BASH_CUSTOMIZATIONS=1