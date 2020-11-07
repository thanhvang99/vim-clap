" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: List the leetcode.

" Need space when searching. Why??
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

function! clap#provider#leetcode#parse(line) abort
  " using regex . not \.
  " using * not \*
  " different ' vs "
  let id = matchstr(a:line,'[\s*\d\+\s*\]')
  " How to use regex OR ???
  let l:id = substitute(l:id,'[',"","g")
  let l:id = substitute(l:id,']',"","g")

  let title = matchstr(a:line,']\s*.*')
  let items = split(a:line,"\r")
  
  let l:title = substitute(l:title,'\s\+'," ","g")
  let l:title = substitute(l:title,'\(Hard\|Easy\|Medium\).*',"","g")
  let l:title = substitute(l:title,'^]\s\+',"","g")
  let l:title = substitute(l:title,'\s*$',"","g")
  let l:title = substitute(tolower(l:title),'\s\+',"-","g")

  return [l:id,l:title]
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
  let [id,title] = clap#provider#leetcode#parse(a:line)
  let root_path = "~/work_space/problems/leetcode/"
  let file =  substitute(l:id,'\s\+',"","g") . '.' . l:title . ".js"
  let path_to_file = l:root_path . l:file
  " let g:name = l:path_to_file
  if !empty(glob(l:path_to_file))
    " let g:test = "existed"
    silent! exe "e " . l:path_to_file
  else
      silent! exe '!leetcode show ' . l:id ' -gx -l javascript -o ~/work_space/problems/leetcode/'
      silent! exe "e " . l:path_to_file
  endif
endfunction

let g:clap#provider#leetcode# = s:leetcode

let &cpoptions = s:save_cpo
unlet s:save_cpo
