#!/bin/bash

# This is to enable true colors in tmux
# Test with tmux info | grep Tc

tmux new-session -d
tmux set-option -ga terminal-overrides ",xterm-256color:Tc"
