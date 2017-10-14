#!/usr/bin/env python3

import time, sys

with open("input", "rb") as f:
    while f:
        params = f.readline().split()
        if not params:
            break
        delay = float(params[0])
        duration = float(params[1])
        count = int(params[2])
        # 1. Delay
        time.sleep(delay)
        keystrokes = f.read(count)
        d = duration / len(keystrokes)
        for k in keystrokes:
            sys.stdout.write("%c" % k)
            sys.stdout.flush()
            time.sleep(d)
        f.read(1)    # newline
