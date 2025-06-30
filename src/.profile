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

set_hidpi_wayland()
{
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_DISABLE_RDD_SANDBOX=1
    #export QT_WAYLAND_FORCE_DPI=140
    export XDG_CURRENT_DESKTOP=Unity
    export SDL_VIDEODRIVER=wayland

    export _JAVA_AWT_WM_NONREPARENTING=1
    export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
    export GDK_SCALE=1.5
    export GDK_DPI_SCALE=1.5
    #export QT_SCALE_FACTOR=1.5
    export QT_FONT_DPI=140
    export XCURSOR_SIZE=32
}

if [[ "$XDG_SESSION_TYPE" == wayland ]]; then
    set_hidpi_wayland
else
#    export GDK_SCALE=2
#    export GDK_DPI_SCALE=0.5
    export MOZ_X11_EGL=1
fi

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then                                                                                   
    set_hidpi_wayland
    exec sway                                                                                                                                   
fi

mesg n || true

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/sakhnik/.sdkman"
[[ -s "/home/sakhnik/.sdkman/bin/sdkman-init.sh" ]] && source "/home/sakhnik/.sdkman/bin/sdkman-init.sh"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

. ~/.bashrc
