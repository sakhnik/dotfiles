#!/bin/bash

[[ "$TERM" =~ tmux ]] && export TERM=${TERM/tmux/xterm}
cmd=`basename ${BASH_SOURCE[0]}`

exec /usr/bin/$cmd $@
