#!/bin/bash

export LANG=uk_UA.utf8

export PATH=$PATH:/bin:/sbin:/usr/sbin
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH
[[ -d $HOME/.bin ]] && export PATH=$HOME/.bin:$PATH

if [[ -x /usr/bin/ruby && -x /usr/bin/gem ]]; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

[[ -f source ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh
