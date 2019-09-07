#!/bin/bash

compgen -c | sort -u | fzf --no-extended --print-query | tail -n 1 | xargs -r i3-msg -t command exec
