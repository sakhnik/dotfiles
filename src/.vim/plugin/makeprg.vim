"
"
"

if exists("loaded_makeprg_plugin")
  finish
endif
let loaded_makeprg_plugin = 1


" Public Interface:
command! -nargs=? CMake call makeprg#cmake(<f-args>)

"Define mappings
nnoremap <leader>mm :update<cr>:make<cr>
nnoremap <leader>mc :call makeprg#SetMakePrg() <bar> make<cr>

"Set Boost.Build.v2 default if possible.
if filereadable("Jamfile") || filereadable("Jamroot")
    set makeprg=bjam
endif
