#!/bin/bash

cat ./src/.config/i3/config |\
    perl -ne 'if (m/\bexec(\s+--no-startup-id)?\s+([^ ]+)/) { print "$2\n"; }' |\
    tr -d \"\[ |\
    sort -u  |\
    while read bin; do
        [[ -z "$bin" ]] && continue
        test -x "$bin" || which "$bin" >/dev/null 2>&1 || {
            echo "i3: couldn't find \`$bin'"
        }
done
