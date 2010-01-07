" Choose build method
function! <SID>SetMakePrg()
    let makeprgs = ['make', 'bjam', 'g++ %']
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
nnoremap <f9> :make<cr>
inoremap <f9> <esc>:make<cr>
nnoremap <c-f9> :call <SID>SetMakePrg() <bar> make<cr>
inoremap <c-f9> <esc>:call <SID>SetMakePrg() <bar> make<cr>

"Set Boost.Build.v2 default if possible.
if filereadable("Jamfile") || filereadable("Jamroot")
    set makeprg=bjam
endif
