#!/usr/bin/env python3

# Capture input keystrokes with timings of a terminal program
# like shell or vim for automated testing.
#
# File format:
# <time from previous burst> <burst duration> <byteCount>
# <... bytes ...>
#

import sys, os, time
import pty

class KeyLogger:
    grouping = 0.4   # group keystrokes that are closer than given time (seconds)

    def __init__(self, fname):
        self.of = open(fname, "wb")
        self.prev_group_end = time.monotonic()
        self.group_start = 0
        self.last_time = 0
        self.buf = b''    # Buffer with grouped incremental input

    def log(self, data):
        now = time.monotonic()

        if not self.group_start:
            self.group_start = now
            self.last_time = now
            self.buf = data
            return

        dt = now - self.last_time
        if dt > KeyLogger.grouping:
            self.write_log()
            self.prev_group_end = self.last_time
            self.group_start = now
            self.last_time = now
            self.buf = data
        else:
            self.last_time = now
            self.buf += data

    def write_log(self):
        self.of.write(b"%.2f %.2f %d\n" % (self.group_start - self.prev_group_end, \
                                           self.last_time - self.group_start, \
                                           len(self.buf)))
        self.of.write(self.buf)
        self.of.write(b"\n")

    def __del__(self):
        self.write_log()

key_logger = KeyLogger("input")

def read(fd):
    return os.read(fd, 1024)

def stdin_read(fd):
    data = os.read(fd, 1024)
    key_logger.log(data)
    return data

pty.spawn('sh', read, stdin_read)
