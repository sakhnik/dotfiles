import os

class PathFixer:
    def __init__(self, projdir):
        self.projdir = projdir
        self.path_pending = False

    def FixOpt(self, opt):
        # Ensure that relative include directories are converted to absolute ones
        opt = opt.strip()

        if self.path_pending:
            self.path_pending = False
            return os.path.join(projdir, opt)

        if opt.startswith('-I'):
            if len(opt) == 2:
                self.path_pending = True
            elif opt[2] != '/':
                return '-I' + os.path.join(projdir, opt[2:])
        return opt
