"
"
"

let s:loaded_makeprg_plugin = '0.1'

if exists("loaded_makeprg_plugin")
  finish
endif
let loaded_makeprg_plugin = 1

" Find directory upwards
function! s:find_builddir(expr)
  let s:build_dir = getcwd()
  while s:build_dir != '/'
    let res = globpath(s:build_dir, a:expr)
    if res != ""
        return split(res)[0]
    endif
    let s:build_dir = fnamemodify(s:build_dir, ':h')
  endwhile
  return ""
endfunction

" Public Interface:
command! -nargs=? CMake call s:cmake(<f-args>)

function! s:cmake(...)
  let s:build_dir = s:find_builddir('BUILD*')
  if s:build_dir != ""
    let &makeprg='make --directory=' . s:build_dir
    for arg in a:000
      let &makeprg .= ' ' . arg
    endfor
    make
  endif
endfunction

" Choose build method
function! <SID>SetMakePrg()
    let makeprgs = ['make', 'bjam', 'g++ -std=c++14 %']
    let prompt_makeprgs = []
    let index = 0
    while index < len(makeprgs)
        let default = &makeprg == makeprgs[index] ? '*' : ' '
        call add(prompt_makeprgs, default . index . '. ' . makeprgs[index])
        let index = index + 1
    endwhile
    let choice = inputlist(prompt_makeprgs)
    if choice >= 0 && choice < len(makeprgs)
        let &makeprg = makeprgs[choice]
    endif
endf

"Define mappings
nnoremap <leader>mm :update<cr>:make!<cr>
nnoremap <leader>mc :call <SID>SetMakePrg() <bar> make<cr>

"Set Boost.Build.v2 default if possible.
if filereadable("Jamfile") || filereadable("Jamroot")
    set makeprg=bjam
endif
