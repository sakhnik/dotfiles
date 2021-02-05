#!/bin/bash

setxkbmap -layout us,ua -option grp:alt_space_toggle,lv3:ralt_switch,compose:rctrl-altgr -model chromebook
xinput set-prop "Elan Touchpad" "libinput Tapping Enabled" 1  # Tap to click
xinput set-prop "Elan Touchpad" "libinput Natural Scrolling Enabled" 1
