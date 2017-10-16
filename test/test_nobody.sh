#!/bin/bash

this_dir=`dirname ${BASH_SOURCE[0]}`
cd $this_dir

sudo su -s /bin/bash nobody -c ./test.sh
