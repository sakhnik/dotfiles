
" Custom errorformats: list of 2-item lists (1 -- name, 2 -- efm string)
function! errorformat#GetAvailableFormats()
  let formats = [
        \ [ 'cancel', '' ],
        \
        \ [ 'cmake', ', %#%f:%l %#(%m)'
        \          . ',%E' . 'CMake Error at %f:%l (%m):'
        \          . ',%Z' . 'Call Stack (most recent call first):'
        \          . ',%C' . ' %m'
        \ ],
        \
        \ [ 'doctest', '%E%f(%l) ERROR!,%E%f(%l) FATAL ERROR!,%-Cwith expansion:,%C %m,%Z,'
        \ ],
        \
        \ [ 'gtest', '%E%f:%l:\ Failure,%Z%m,' ]
        \ ]
  return formats
endfunction

" Prepend or append depending on the tailing or leading comma given format to the &efm
function! errorformat#Set(format)
  if len(a:format) == 0 || strridx(&efm, a:format) != -1
    return
  endif

  if a:format[0] == ','
    let &efm .= a:format
  else
    let &efm = a:format . &efm
  endif
endfunction

" Ask a user to choose a custom format
function! errorformat#Choose()
  let formats = errorformat#GetAvailableFormats()
  let keys = map(copy(formats), {i -> i . '. ' . formats[i][0]})
  let choice = inputlist(keys)
  if choice < 0 || choice >= len(formats)
    return
  endif

  call errorformat#Set(formats[choice][1])
endfunction

" Set all custom error formats
function! errorformat#AddAll()
  for format in errorformat#GetAvailableFormats()
    call errorformat#Set(format[1])
  endfor
endfunction
