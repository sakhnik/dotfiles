#!/usr/bin/env python3

# Capture input keystrokes with timings of a terminal program
# like shell or vim for automated testing.
#
# File format:
# <time> <byteCount>
# <... bytes ...>
# <time> <byteCount>
# <... bytes ...>
#

import sys, os, time
import pty

class KeyLogger:
    grouping = 1.0   # group keystrokes by 1 second

    def __init__(self, fname):
        self.of = open(fname, "wb")
        self.last_time = time.monotonic()
        self.last_dt = 0.0
        self.buf = b''    # Buffer with grouped incremental input

    def log(self, data):
        now = time.monotonic()
        dt = now - self.last_time
        if dt > KeyLogger.grouping:
            self.of.write(b"%f %d\n" % (self.last_dt, len(self.buf)))
            self.of.write(self.buf)
            self.of.write(b"\n")
            self.last_time = now
            self.buf = data
            self.last_dt = dt - self.last_dt
        else:
            self.buf += data
            self.last_dt = dt

    def __del__(self):
        self.of.write(b"%f %d\n" % (self.last_dt, len(self.buf)))
        self.of.write(self.buf)
        self.of.write(b"\n")

key_logger = KeyLogger("input")

def read(fd):
    return os.read(fd, 1024)

def stdin_read(fd):
    data = os.read(fd, 1024)
    key_logger.log(data)
    return data

pty.spawn('sh', read, stdin_read)
