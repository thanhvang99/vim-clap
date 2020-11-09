" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: List the gist.

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:gist = {}

function! clap#provider#gist#source_common(buffer_local) abort
  let source = "gist -l " . g:github_user
  return source
endfunction

function! s:gist.source() abort
  return clap#provider#gist#source_common(v:false)
endfunction

function! clap#provider#gist#parse_rev(line) abort
  let b = matchstr(a:line,'com/[0-9a-zA-z]\+\s')
  " How to use regex OR ???
  let l:b = substitute(l:b,"com/","","g")
  return l:b
endfunction


function! s:gist.sink(line) abort
  let rev = clap#provider#gist#parse_rev(a:line)
  vertical belowright new
  exe "Gist " . rev
endfunction


let g:clap#provider#gist# = s:gist

let &cpoptions = s:save_cpo
unlet s:save_cpo
