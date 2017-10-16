#!/usr/bin/env python3

# Replay prerecorded interactive shell session

import time, os, sys
import subprocess, pty
import argparse

parser = argparse.ArgumentParser(description='Replay prerecorded terminal session.')
parser.add_argument('file', nargs='?', default='input', help='input with timings (see record.py)')
parser.add_argument('-a', '--accel', type=float, default=1.0, help='acceleration factor (default 1.0)')
parser.add_argument('-q', '--quiet', action='store_true', help='suppress terminal output')

args = parser.parse_args(sys.argv[1:])

# Create a generator that returns (delay, keycode) on each iteration
def InputReader():
    with open(args.file, "rb") as f:
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

stdout = None
stderr = None
if args.quiet:
    stdout = subprocess.DEVNULL
    stderr = subprocess.DEVNULL

# Run shell in a PTY
master, slave = pty.openpty()
child = subprocess.Popen(['bash'], stdin=slave, stdout=stdout, stderr=stderr)

# Feed the child with timed input
keys = InputReader()
for d,k in keys:
    time.sleep(d / args.accel)
    os.write(master, b'%c' % k)
