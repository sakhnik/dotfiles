#!/usr/bin/env python3

import time, os, sys
import subprocess, pty

def InputReader():
    with open("input", "rb") as f:
        while f:
            params = f.readline().split()
            if not params:
                break
            delay = float(params[0])
            duration = float(params[1])
            count = int(params[2])
            keystrokes = f.read(count)
            d = 0
            if count > 1:
                d = duration / (count - 1)
            for k in keystrokes:
                yield delay, k
                delay = d
            f.read(1)    # newline

master, slave = pty.openpty()
vim = subprocess.Popen(['bash'], stdin=slave)

keys = InputReader()
for d,k in keys:
    time.sleep(d)
    os.write(master, b'%c' % k)
