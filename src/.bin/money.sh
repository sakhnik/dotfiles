#!/usr/bin/bash

set -e

this_dir=`dirname ${BASH_SOURCE[0]}`

(
    encfs --extpass $this_dir/data.passwd.sh ~/.Private ~/Private

    finish()
    {
        popd
        fusermount -u ~/Private
    }
    trap finish EXIT

    pushd ~/Private/money
    zsh
)

# Copy to the backup drives is mounted
for dir in /run/media/$USER/sakhnik*; do
    if mountpoint -q $dir; then
        rsync -raP --delete ~/.Private $dir/
    fi
done

# Copy to other stations
rsync -raP --delete ~/.Private alarmpi3:~
