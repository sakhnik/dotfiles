" Update tags file near the Jamroot
" A. Sakhnik, 4th of November 2008

function! <SID>UpdateTags()
    " Starting from the current directory, go up looking for a Jamroot.
    let tdir = getcwd()
    while tdir != "/"
        if filereadable(tdir . "/Jamroot")
            echomsg "Updating tags..."
            " Create the tags file in it.
            let cmd = ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "
            let cmd = cmd . "--languages=c++ "
            let cmd = cmd . "-f " . tdir . "/tags " . tdir
            exec cmd
            " Update the option tags
            let &tags = tdir . "/tags"
            let &tags = &tags . "," . $HOME . "/.vim/tags/tags.glibc"
            let &tags = &tags . "," . $HOME . "/.vim/tags/tags.stl"
            let &tags = &tags . "," . $HOME . "/.vim/tags/tags.ace"
            let &tags = &tags . "," . $HOME . "/.vim/tags/tags.linux"
            return
        endif 
        let tdir = fnamemodify(tdir, ":p:h:h")
    endw
    echomsg "Where is the Jamroot???"
endf

nmap <f12> :call <SID>UpdateTags()<cr><c-l>
