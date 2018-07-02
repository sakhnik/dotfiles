#!/bin/sh -e

# Take a screenshot
#import -window root /tmp/screen_locked.png

# Pixellate it 10x
#mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
#mogrify -blur 0x16 /tmp/screen_locked.png

# Ensure English keyboard to easy unlocking
xkb-switch -s us

# Lock screen displaying this image.
i3lock -c 777777 #-i /tmp/screen_locked.png

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
