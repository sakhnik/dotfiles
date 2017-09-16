bindkey -v

local zshrc_path=`readlink -f ${(%):-%x}`
local zshrc_dir=`dirname $zshrc_path`

export ZPLUG_HOME=`dirname $zshrc_dir`/.zplug
export ZPLUG_REPOS=$ZPLUG_HOME/repos
export ZPLUG_CACHE_DIR=$ZPLUG_HOME/cache
export ZPLUG_BIN=$ZPLUG_HOME/bin

if [[ ! -d $ZPLUG_HOME ]]; then
    git clone --depth 1 https://github.com/zplug/zplug $ZPLUG_HOME
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "zsh-users/zsh-completions"

zplug mafredri/zsh-async, use:async.zsh, from:github, defer:0  # Load this first
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
PURE_PROMPT_SYMBOL='$'
PURE_GIT_UP_ARROW='↑'
PURE_GIT_DOWN_ARROW='↓'

if [[ -d $zshrc_dir/.vim/plugged/fzf ]]; then
    # Assume fzf can be installed by other means (like vim)
    zplug "$zshrc_dir/.vim/plugged/fzf/shell", from:local, use:'*.zsh'
fi

zplug check || zplug install
zplug load

# Edit command line in EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^F' edit-command-line

# Paths to search binaries
if [[ -d $zshrc_dir/.bin ]]; then
    case "$PATH" in
        *$zshrc_dir/.bin*) ;;
        *) export PATH=$zshrc_dir/.bin:$PATH ;;
    esac
fi

local fzf_dir=$zshrc_dir/.vim/plugged/fzf/bin
if [[ -d $fzf_dir ]]; then
    case "$PATH" in
        *$fzf_dir*) ;;
        *) export PATH=$PATH:$fzf_dir ;;
    esac
fi
unset fzf_dir

export CTEST_OUTPUT_ON_FAILURE=1

if [[ -x /usr/bin/nvim || -x /usr/local/bin/nvim ]]; then
    alias vim=nvim
    alias vimdiff="nvim -d"
    export EDITOR=nvim
else
    export EDITOR=vim
fi

[[ -f $zshrc_dir/../pystartup.py ]] &&
    export PYTHONSTARTUP=$zshrc_dir/../pystartup.py
unset zshrc_dir
unset zshrc_path

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'

    if [[ -f /usr/bin/grep ]]; then
        alias grep='/usr/bin/grep --color'
    elif [[ -f /bin/grep ]]; then
        alias grep='/bin/grep --color'
    fi
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

######################################################
# Options

# Enable job control
set -o monitor
# Check running jobs on exit
set -o check_jobs
# Disable beeps
set -o no_beep
# Enable spellcheck
set -o correct
# Better jobs
set -o long_list_jobs

[[ -n "$PS1" ]] && {
echo "Terminal true color test"
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
}

# vim: set ts=4 sw=4 et:
