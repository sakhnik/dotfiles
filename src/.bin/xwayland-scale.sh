#!/bin/bash

scale="${1:-2}"

swaymsg xwayland scale "$scale"
echo Gdk/WindowScalingFactor "$scale" > ~/.config/xsettingsd/xsettingsd.conf
killall -HUP xsettingsd
