" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: List the gist.

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:gist = {}

function! clap#provider#gist#source_common(buffer_local) abort
  let source = "gist '--list'"
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

function! clap#provider#gist#sink_inner(bang_cmd) abort
  vertical botright new
  setlocal buftype=nofile bufhidden=wipe noswapfile nomodeline

  setlocal modifiable
  silent execute 'read' escape(a:bang_cmd, '%')
  normal! gg"_dd
  setfiletype gist
  setlocal nomodifiable
endfunction

function! s:gist.sink(line) abort
  let rev = clap#provider#gist#parse_rev(a:line)
  call clap#provider#gist#sink_inner('!gist -r '. rev)
endfunction

" let s:gist.syntax = 'none'

let g:clap#provider#gist# = s:gist

let &cpoptions = s:save_cpo
unlet s:save_cpo
