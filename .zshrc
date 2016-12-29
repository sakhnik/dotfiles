bindkey -v

if [[ ! -d ~/.zplug ]]; then
	git clone --depth 1 https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "zsh-users/zsh-completions"

zplug mafredri/zsh-async, use:async.zsh, from:github, defer:0  # Load this first
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
PURE_PROMPT_SYMBOL='$'
PURE_GIT_UP_ARROW='↑'
PURE_GIT_DOWN_ARROW='↓'

if [[ -d ~/.fzf ]]; then
	# Assume fzf can be installed by other means (like vim)
	zplug "~/.fzf/shell", from:local, use:'*.zsh'
fi

zplug check || zplug install
zplug load

# Edit command line in EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^F' edit-command-line

# Paths to search binaries
export PATH=$PATH:/bin:/sbin:/usr/sbin
[[ -d ~/.bin ]] && export PATH=~/.bin:$PATH
[[ -d ~/bin ]] && export PATH=~/bin:$PATH
[[ -d ~/.fzf/bin ]] && export PATH=$PATH:~/.fzf/bin

if [[ -x /usr/bin/ruby && -x /usr/bin/gem ]]; then
	PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

if [[ -x /usr/bin/nvim || -x /usr/local/bin/nvim ]]; then
	alias vim=nvim
	alias vimdiff="nvim -d"
	export EDITOR=nvim
else
	export EDITOR=vim
fi

local this_dir=$(dirname `readlink -f ~/.zshrc`)
[[ -f $this_dir/pystartup.py ]] &&
	export PYTHONSTARTUP=$this_dir/pystartup.py
unset this_dir

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
setopt monitor
# Check running jobs on exit
setopt check_jobs
# Disable beeps
setopt no_beep
# Enable spellcheck
setopt correct
# Better jobs
setopt long_list_jobs

# vim: set ts=4 sw=4 noet:
