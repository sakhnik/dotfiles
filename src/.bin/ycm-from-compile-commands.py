#!/usr/bin/env python3

# Create .ycm_extra_conf.py from compile_commands.json
# This is useful when header files are named randomly
# and unrelatedly to source files.

import json
import re
import os


# Get options with system include directories.
# This is useful to get completion of include headers.
def GetSystemIncludes():
    script='''
    echo \
        | clang -v -E -x c++ - 2>&1 \
        | awk '/#include <...>/,/End of search/' \
        | while read -r l; do
            [[ -d "$l" ]] && echo "-isystem`readlink -f $l`" || true
        done
    '''
    return os.popen(script).read().splitlines()

def GetCompileCommandsOptions(section):
    # The build directory.
    directory = section["directory"]

    # Original options
    opts = re.split(r'\s+', section["command"])
    opts = opts[1:]   # ignore compiler command

    # The options to ignore
    blacklist = ['-fPIC', '-g', '-O2', '-DNDEBUG']

    # The options with arguments to ignore
    blacklist_args = ['-o', '-c']

    # The resulting options.
    target_opts = []

    i = 0
    n = len(opts)
    while i < n:
        o = opts[i]
        if o in blacklist:
            i += 1
            continue
        if o in blacklist_args:
            i += 2
            continue
        if o.startswith('-I'):
            # Make sure includes are listed with full path.
            o = '-I' + os.path.normpath(os.path.join(directory, o[2:]))
        if o.startswith('-D'):
            # Make sure the quotes aren't escaped too much in definitions.
            o = re.sub(r'-D([^=]*)=\\"(.*)\\"', '-D\\1="\\2"', o)
        target_opts.append(o)
        i += 1

    return target_opts

# Load compile_commands.json from current working directory.
with open("compile_commands.json", "r") as f:
    js = json.load(f)

# Consider the first source file.
sect = js[0]

target_opts = ['-xc++'] + GetCompileCommandsOptions(sect) + GetSystemIncludes()

# Write out .ycm_extra_conf.py
with open('.ycm_extra_conf.py', 'w') as f:
    f.write('''
def Settings( **kwargs ):
  return {
    'flags': ''')
    f.write(str(target_opts))
    f.write('''
  }''')

