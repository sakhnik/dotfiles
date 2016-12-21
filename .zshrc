if [[ ! -d ~/.zplug ]]; then
	git clone --depth 1 https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "modules/history", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/directory", from:prezto
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
#zplug "zsh-users/zsh-autosuggestions"   # Carefull: slow in MSYS!
zplug "zsh-users/zsh-completions"
zplug mafredri/zsh-async, from:github, defer:0  # Load this first
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

zplug check || zplug install
zplug load


export PATH=$PATH:/bin:/sbin:/usr/sbin
[[ -d $HOME/.bin ]] && export PATH=$HOME/.bin:$PATH
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH

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

this_dir=$(dirname `readlink -f ~/.zshrc`)
[[ -f $this_dir/pystartup.py ]] &&
	export PYTHONSTARTUP=$this_dir/pystartup.py

bindkey -v

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

# vim: set ts=4 sw=4 noet:
