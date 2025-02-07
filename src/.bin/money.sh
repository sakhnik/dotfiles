#!/bin/bash -e

(
    (DISPLAY= pass Encfs/data) | \
        encfs --stdinpass ~/.Private ~/Private

    finish()
    {
        popd
        fusermount -u ~/Private
    }
    trap finish EXIT

    pushd ~/Private/money
    LEDGER_FILE=~/Private/money/cur.dat $SHELL
)

# Copy to the backup drives is mounted
for dir in /run/media/"$USER"/sakhnik*; do
    if mountpoint -q "$dir"; then
        rsync -raP --delete ~/.Private "$dir/"
    fi
done

# Copy to other stations
#(rsync -raP --delete ~/.Private home-rpi4:/home/sakhnik) &
(rsync -raP --delete ~/.Private wg-rpi4:/home/sakhnik) &
(rsync -raP --delete ~/.Private iryska:/root) &
wait
