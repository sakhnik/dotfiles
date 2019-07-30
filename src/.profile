#!/bin/bash

export LANG=uk_UA.utf8

export PATH=$PATH:/bin:/sbin:/usr/sbin
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH
[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH

if [[ -x /usr/bin/ruby && -x /usr/bin/gem ]]; then
    PATH="$(ruby -rrubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if [[ -x /usr/bin/luarocks-5.1 ]]; then
    eval "$(luarocks-5.1 path)"
fi

if [[ "$XDG_SESSION_TYPE" == wayland ]]; then
    export MOZ_ENABLE_WAYLAND=1
fi

mesg n || true

#!/bin/bash
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/sakhnik/.sdkman"
[[ -s "/home/sakhnik/.sdkman/bin/sdkman-init.sh" ]] && source "/home/sakhnik/.sdkman/bin/sdkman-init.sh"
