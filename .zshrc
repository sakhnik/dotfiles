
export PATH=$PATH:/bin:/sbin:/usr/sbin
if [[ -d $HOME/bin ]]; then
	export PATH=$HOME/bin:$PATH
fi

export LANG=uk_UA.UTF-8

#[[ -z "$TMUX" ]] && exec tmux

alias ubuntu="schroot -c ubuntu -p"

export EDITOR=vim
[[ -f $HOME/.sakhnik/pystartup.py ]] &&
	export PYTHONSTARTUP=$HOME/.sakhnik/pystartup.py

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

autoload -U promptinit && {
	promptinit

	#prompt pws
	export ZSH_THEME_GIT_PROMPT_NOCACHE=1
	source ~/.zsh/git-prompt/zshrc.sh

	# set variable indentifying the chroot you work in (used in the prompt below)
	if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
		debian_chroot=$(cat /etc/debian_chroot)
	fi

	chroot='${debian_chroot:+($debian_chroot)}'

	PROMPT='%(?..[%?] )'       # Exit code of the previous command if failed
	PROMPT=$PROMPT${chroot}
	PROMPT=$PROMPT'%{$fg[green]%}%B%m%{$reset_color%}%b' # Host name
	PROMPT=$PROMPT':%{$fg[blue]%}%B%5(~.%~
.%~)%b%{$reset_color%}'        # Current working directory (newline if at least 5 elements)
	PROMPT=$PROMPT'$(git_super_status) %# '
}

autoload -U colors && colors

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
alias urldecode='python2 -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

if fortune -e 2>/dev/null; then
	echo
fi

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------

autoload -U compinit && {

	# Init completion, ignoring security checks.
	compinit -C

	# Force rehash to have completion picking up new commands in path.
	_force_rehash() { (( CURRENT == 1 )) && rehash; return 1 }
	zstyle ':completion:::::' completer _force_rehash \
	                                    _complete \
	                                    _ignored \
	                                    _gnu_generic \
	                                    _approximate
	zstyle ':completion:*'    completer _complete \
	                                    _ignored \
	                                    _gnu_generic \
	                                    _approximate

	# Speed up completion by avoiding partial globs.
	zstyle ':completion:*' accept-exact '*(N)'
	zstyle ':completion:*' accept-exact-dirs true

	# Cache setup.
	zstyle ':completion:*' use-cache on

	# Default colors for listings.
	zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

	# Separate directories from files.
	zstyle ':completion:*' list-dirs-first true

	# Turn on menu selection only when selections do not fit on screen.
	#zstyle ':completion:*' menu true=long select=long

	# Separate matches into groups.
	zstyle ':completion:*:matches' group yes
	zstyle ':completion:*' group-name ''

	# Always use the most verbose completion.
	zstyle ':completion:*' verbose true

	# Treat sequences of slashes as single slash.
	zstyle ':completion:*' squeeze-slashes true

	# Describe options.
	zstyle ':completion:*:options' description yes

	# Completion presentation styles.
	zstyle ':completion:*:options' auto-description '%d'
	zstyle ':completion:*:descriptions' format $'\e[1m -- %d --\e[22m'
	zstyle ':completion:*:messages'     format $'\e[1m -- %d --\e[22m'
	zstyle ':completion:*:warnings'     format $'\e[1m -- No matches found --\e[22m'

	# Ignore hidden files by default
	zstyle ':completion:*:(all-|other-|)files'  ignored-patterns '*/.*'
	zstyle ':completion:*:(local-|)directories' ignored-patterns '*/.*'
	zstyle ':completion:*:cd:*'                 ignored-patterns '*/.*'

	# Don't complete completion functions/widgets.
	zstyle ':completion:*:functions' ignored-patterns '_*'

	# Don't complete uninteresting users.
	zstyle ':completion:*:*:*:users' ignored-patterns adm amanda apache avahi \
		beaglidx bin cacti canna clamav daemon dbus distcache dovecot junkbust  \
		games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident ftp fax \
		ldap lp mail mailman mailnull mldonkey mysql nagios named netdump news  \
		nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix postgres \
		privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown squid sshd sync \
		uucp vcsa xfs www-data avahi-autoipd gitblit http rtkit sabnzbd usbmux  \
		sickbeard

	# Show ignored patterns if needed.
	zstyle '*' single-ignored show

	# cd style.
	zstyle ':completion:*:cd:*' ignore-parents parent pwd # cd never selects the parent directory (e.g.: cd ../<TAB>)
	zstyle ':completion:*:*:cd:*' tag-order local-directories path-directories

	# kill style.
	zstyle ':completion:*:*:kill:*' command 'ps -a -w -w -u $USER -o pid,cmd --sort=-pid'
	zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=39=32"

	# rm/cp/mv style.
	zstyle ':completion:*:(rm|mv|cp):*' ignore-line yes

	# Hostnames completion.
	zstyle -e ':completion:*:hosts' hosts 'reply=(
		${${${${(f)"$(<~/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}
		${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
		${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}#*[[:blank:]]}}
		)'
	zstyle ':completion:*:*:*:hosts' ignored-patterns 'ip6*' 'localhost*'

	# Use zsh-completions if available.
	[[ -d $MAIN_USER_HOME/projects/zsh-completions ]] && fpath=($MAIN_USER_HOME/projects/zsh-completions/src $fpath)

	# Completion debugging
	bindkey '^Xh' _complete_help
	bindkey '^X?' _complete_debug

	setopt AUTO_LIST
	unsetopt AUTO_MENU
	unsetopt MENU_COMPLETE
}

# Bash-style ^W
autoload -U select-word-style && select-word-style bash

# Edit command line in editor
autoload -U edit-command-line && {
	zle -N edit-command-line
	bindkey '^f' edit-command-line
}

autoload -U up-line-or-beginning-search && {
	zle -N up-line-or-beginning-search
	bindkey '^P' up-line-or-beginning-search
}

autoload -U down-line-or-beginning-search && {
	zle -N down-line-or-beginning-search
	bindkey '^N' down-line-or-beginning-search
}


# backspace and ^h working even after returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
bindkey -a G end-of-buffer-or-history

bindkey -a u undo
bindkey -a '^R' redo
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# vi-mode: distinguish normal mode
precmd() {
	RPROMPT=""
}
zle-keymap-select() {
	RPROMPT=""
	[[ $KEYMAP = vicmd ]] && RPROMPT="(CMD)"
	() { return $__prompt_status }
	zle reset-prompt
}
zle-line-init() {
	typeset -g __prompt_status="$?"
}
zle -N zle-keymap-select
zle -N zle-line-init


# Fuzzy file finder in the current subtree
fzf-file-widget() {
	local FILES
	local IFS="
"
	FILES=($(
	find * -path '*/\.*' -prune \
		-o -type f -print \
		-o -type l -print 2> /dev/null | fzf -m))
	unset IFS
	FILES=$FILES:q
	LBUFFER="${LBUFFER%% #} $FILES"
	zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^P' fzf-file-widget

# Open selected file in vim
vf() {
	file=$(fzf) && vim "$file"
}
