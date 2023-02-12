#!/bin/bash -e

(DISPLAY= pass Encfs/pictures) | \
    encfs --stdinpass /mnt/pictures/.Private ~/mnt

finish()
{
    popd
    fusermount -u ~/mnt
}
trap finish EXIT

pushd ~/mnt
zsh
