
" Find directory upwards
function! makeprg#find_builddir(expr)
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

function! makeprg#CMake(...)
  let s:build_dir = makeprg#find_builddir('BUILD*')
  if s:build_dir != ""
    let &makeprg='make --directory=' . s:build_dir
    for arg in a:000
      let &makeprg .= ' ' . arg
    endfor
    make
  endif
endfunction

function! makeprg#CMakeDefault()
  " Find the first available build directory
  let build_dir = makeprg#find_builddir('BUILD*')

  if build_dir != ""
    " Detect how many concurrent jobs are possible on this CPU: cpus + 1
    let jobopts = ''
    if filereadable('/proc/cpuinfo')
      let jobcount = system('grep -c ^processor /proc/cpuinfo') + 1
      let jobopts = ' -j'.jobcount
    endif

    " Detect what command is used to build the source: make or ninja
    let makecmd = 'make'
    if filereadable(build_dir . '/build.ninja')
      let makecmd = 'ninja'
    endif

    " Set the option 'makeprg' and build the code
    let &makeprg = makecmd . ' -C ' . build_dir . jobopts
    make
  else
    echoerr "Couldn't find BUILD*/"
  endif
endfunction

" Choose build method
function! makeprg#SetMakePrg()
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
        make
    endif
endf
