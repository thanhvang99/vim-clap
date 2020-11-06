" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: List the leetcode.

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:leetcode = {}

function! clap#provider#leetcode#source_common(query) abort
  let dict = {"easy": "e","medium": "m","hard": "h"}
  if empty(a:query)
    let source = "leetcode list" 
    return source
  else
    let source = "leetcode list -q " . dict[a:query]
    return source
  endif
endfunction

function! s:leetcode.source() abort
  if has_key(g:clap.context,'opt')
    let query = g:clap.context.opt
    return clap#provider#leetcode#source_common(query)
  else
    return clap#provider#leetcode#source_common("")
  endif
endfunction

function! clap#provider#leetcode#parse_rev(line) abort
  " using regex . not \.
  " using * not \*
  " different ' vs "
  let b = matchstr(a:line,'[\s*\d\+\s*\]')
  " How to use regex OR ???
  let l:b = substitute(l:b,'[',"","g")
  let l:b = substitute(l:b,']',"","g")
  let g:test = b
  return l:b
endfunction

function! clap#provider#leetcode#sink_inner(bang_cmd) abort
  vertical botright new
  setlocal buftype=nofile bufhidden=wipe noswapfile nomodeline

  setlocal modifiable
  silent execute 'read' escape(a:bang_cmd, '%')
  normal! gg"_dd
  setfiletype diff
  setlocal nomodifiable
endfunction

function! s:leetcode.sink(line) abort
  let rev = clap#provider#leetcode#parse_rev(a:line)
  call clap#provider#leetcode#sink_inner('!leetcode show '.rev)
endfunction

let g:clap#provider#leetcode# = s:leetcode

let &cpoptions = s:save_cpo
unlet s:save_cpo
