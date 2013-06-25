" avoid reinclusion for the same buffer. keep it buffer local so it can be
" externally reset in case of emergency re-sourcing.
if exists('b:doneCmakeCompiler')
	finish
endif
let b:doneCmakeCompiler = 1

" CMake Parser
" Call stack entries
let &efm = ' %#%f:%l %#(%m)'
" Start of multi-line error
let &efm .= ',%E' . 'CMake Error at %f:%l (message):'
" End of multi-line error
let &efm .= ',%Z' . 'Call Stack (most recent call first):'
" Continuation is message
let &efm .= ',%C' . ' %m'
