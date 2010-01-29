# .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# set variable indentifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(__git_ps1 " [%s]")\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# User specific aliases and functions

# vi mode
set -o vi
# ^p check for partial match in history
bind -m vi-insert "\C-p":dynamic-complete-history
# ^n cycle through the list of partial matches
bind -m vi-insert "\C-n":menu-complete
# ^l clear screen
bind -m vi-insert "\C-l":clear-screen
# Don't rewrite non-empty files
set -o noclobber

shopt -s histappend
shopt -s cdspell
shopt -s cmdhist
shopt -s checkwinsize
shopt -s nocaseglob
PROMPT_COMMAND='history -a; [[ $TERM == "linux" ]] && echo -en "\e[?81;0;112c"'
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTSIZE=3000
export HISTTIMEFORMAT="%d.%m.%Y %H:%M:%S  "

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

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

vman()
{
    text=`man $*` || return $?
    echo "$text" | col -b | vim -c 'set ft=man nomod nolist' -
}

#export MANPAGER="/bin/sh -c \"unset MANPAGER;col -b -x | \
#    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
#        -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
#        -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

export BOOST_BUILD_PATH="/usr/share/boost-build"
export STARDICT_DATA_DIR="/usr/local/share/stardict"
export SDCV_PAGER="/bin/more"

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    complete -F _man $filenames vman
fi

if [ -n "$PS1" ]; then
    echo
    /usr/games/fortune -e
    echo
    todo=$(calendar)
    if [ ! -z "$todo" ]; then
        echo "$todo"
        echo
    fi
fi

ruler()
{
    for s in '....^....|' '1234567890'; do
        w=${#s}
        str=$( for (( i=1; $i<=$(( ($COLUMNS + $w) / $w )) ; i=$i+1 )); do
                   echo -n $s
               done )
        str=$(echo $str | cut -c -$COLUMNS)
        echo $str
    done
}
