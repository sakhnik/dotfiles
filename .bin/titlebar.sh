#!/bin/bash

# Hide titlebar in maximized windows

windows=$(xprop -root | grep '_NET_CLIENT_LIST(WINDOW)' | sed -e 's/^[^#]\+#//' -e 's/,//g')

for id in $windows; do
	state=$(xprop -id $id | grep '_NET_WM_STATE(ATOM)')
	if echo "$state" | grep -q _NET_WM_STATE_MAXIMIZED_HORZ; then
		if echo "$state" | grep -q _NET_WM_STATE_MAXIMIZED_VERT; then
			xprop -id $id -f _GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED 32c -set _GTK_HIDE_TITLEBAR_WHEN_MAXIMIZED 1
		fi
	fi
done
