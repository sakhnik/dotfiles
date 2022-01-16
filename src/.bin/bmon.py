#!/usr/bin/env python

import time
import subprocess


bpath = '/sys/class/power_supply/BAT0'
level_step = 5


def read_file(path):
    with open(path, 'rb') as f:
        return f.read()


def cur_charge():
    now = int(read_file(f"{bpath}/charge_now"))
    full = int(read_file(f"{bpath}/charge_full"))
    return 100 * now // full


def notify_send(msg, timeout_ms):
    args = ['notify-send', msg]
    if timeout_ms:
        args += ['-t', str(timeout_ms)]
    subprocess.run(args)


def calc_level(charge):
    return (charge + level_step - 1) // level_step


charge = cur_charge()
notify_send(f"Battery: {charge}", 5000)
prev_level = calc_level(charge)

while True:
    time.sleep(10)
    charge = cur_charge()
    level = calc_level(charge)
    print(f"charge={charge} level={level}")

    if level != prev_level:
        notify_send(f"Battery: {charge}", 5000 if charge > 30 else None)
        prev_level = level
