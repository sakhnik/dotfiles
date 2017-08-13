if !exists("s:init")
    let s:init = 1
endif


function! gdbconf#me() abort
    " user special config
    let this = {
        \ "Scheme" : 'gdb#SchemeCreate',
        \ "autorun" : 1,
        \ "reconnect" : 0,
        \ "showbreakpoint" : 0,
        \ "showbacktrace" : 0,
        \ "conf_gdb_layout" : ["sp", "normal J"],
        \ "conf_gdb_cmd" : ['gdb -q -f', 'a.out'],
        \ "window" : [
        \   {   "name":   "gdbserver",
        \       "status":  0,
        \   },
        \ ],
        \ "state" : {
        \ }
        \ }

    return this
endfunc
