"
"
"

if exists("loaded_makeprg_plugin")
  finish
endif
let loaded_makeprg_plugin = 1


" Public Interface:
command! -nargs=? CMake call makeprg#CMake(<f-args>)

"Define mappings
nnoremap <leader>mm :update<cr>:make!<cr>
nnoremap <leader>mc :update<cr>:call makeprg#CMakeDefault()<cr>
nnoremap <leader>mM :call makeprg#SetMakePrg()<cr>
nnoremap <leader>mt :update<cr>:make! test<cr>

"Set Boost.Build.v2 default if possible.
if filereadable("Jamfile") || filereadable("Jamroot")
    set makeprg=bjam
endif
