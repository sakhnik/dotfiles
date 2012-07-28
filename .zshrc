# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sakhnik/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt walters

autoload -U colors
colors

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
    export GREP_OPTIONS='--colour=auto'
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias cal='cal -m'
alias timidity='timidity -Os'

if fortune -e 2>/dev/null; then
    echo
fi
