#!/bin/bash

export HOME=$(readlink -f `dirname ${BASH_SOURCE[0]}`)/src
exec zsh $@
