import os
import ycm_core

flags = []

def MakeProjectRelativePathAbsolute(projdir, p):
    if p[:2] == '-I' and p[2] != '/':
        return '-I' + os.path.join(projdir, p[2:])
    return p

def DirectoryOfThisScript():
    return os.path.dirname( os.path.abspath( __file__ ) )

projdir = DirectoryOfThisScript()
fname = os.path.join(projdir, '.clang_complete')
with open(fname, 'r') as f:
    for line in f:
        l = line.strip()
        if not l or l[0] == '#':
            continue
        flags.append(MakeProjectRelativePathAbsolute(projdir, l))

flags.append('-Wall')
flags.append('-Wextra')
flags.append('-I.')

def FlagsForFile(filename):
    return { 'flags': flags, 'do_cache': True }
