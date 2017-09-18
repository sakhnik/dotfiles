import os, sys
import ycm_core

# Path to lib directory: `dirname __file__`/../../lib
libdir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.readlink(__file__)))), 'lib')
sys.path.append(libdir)
from cproj import PathFixer

flags = []

# Find closest project root
projdir = os.getcwd()
while not os.path.exists(os.path.join(projdir, '.cproj')):
    projdir = os.path.dirname(projdir)
    if projdir == '/':
        break

fname = os.path.join(projdir, '.clang_complete')
with open(fname, 'r') as f:
    path_fixer = PathFixer(projdir)
    for line in f:
        if not line or line[0] == '#':
            continue
        flags.append(path_fixer.FixOpt(line))

flags.append('-Wall')
flags.append('-Wextra')
flags.append('-I.')

def FlagsForFile(filename):
    return { 'flags': flags, 'do_cache': True }
