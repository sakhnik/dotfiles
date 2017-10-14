#!/usr/bin/env python3


with open("input", "rb") as f:
    while f:
        params = f.readline().split()
        if not params:
            break
        delay = float(params[0])
        duration = float(params[1])
        count = int(params[2])
        print(delay, duration, count)
        keystrokes = f.read(count)
        print(keystrokes)
        f.read(1)
