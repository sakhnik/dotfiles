if [[ ! -d ~/.zplug ]]; then
	git clone --depth 1 https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "molovo/filthy", as:theme, use:"*.zsh"
zplug "modules/history", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/directory", from:prezto
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

zplug check || zplug install
zplug load


export PATH=$PATH:/bin:/sbin:/usr/sbin
[[ -d $HOME/.bin ]] && export PATH=$HOME/.bin:$PATH
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH

if which ruby >/dev/null 2>&1 && which gem >/dev/null 2>&1; then
	PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

if which nvim >/dev/null 2>&1; then
	alias vim=nvim
	alias vimdiff="nvim -d"
	export EDITOR=nvim
else
	export EDITOR=vim
fi

[[ -f $HOME/$this_dir/pystartup.py ]] &&
	export PYTHONSTARTUP=$HOME/$this_dir/pystartup.py

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
