#!/bin/bash -e

fname="/tmp/screen_`date +%Y-%m-%d_%H:%M:%S`.png"

import -window root $fname
chmod go-a $fname
