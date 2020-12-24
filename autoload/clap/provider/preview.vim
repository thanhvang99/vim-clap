" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: List the preview.

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:preview = {}
let s:begin = '^[^0-9]*[0-9]\{4}-[0-9]\{2}-[0-9]\{2}\s\+'

function! clap#provider#preview#source_common(buffer_local) abort
  let git_root = clap#path#get_git_root()
  if empty(git_root)
    return ['Not in git repository']
  endif

  let source = "git log '--color=never' '--date=short' '--format=%cd %h%d %s (%an)'"

  let current = bufname(g:clap.start.bufnr)
  if empty(current)
    return ['buffer name is empty']
  endif

  call system('git show '.current.' 2> '.(has('win32') ? 'nul' : '/dev/null'))

  if v:shell_error
    return ['The current buffer is not in the working tree']
  endif

  if a:buffer_local
    return source." '--follow' '--' ".current
  else
    return source.' --graph'
  endif
endfunction

function! s:preview.source() abort
  return clap#provider#preview#source_common(v:true)
endfunction

function! clap#provider#preview#parse_rev(line) abort
  return matchstr(a:line, s:begin.'\zs[a-f0-9]\+')
endfunction


let g:output_save=""
function! s:preview.sink(line) abort
  let rev = clap#provider#preview#parse_rev(a:line)
  redir => g:output_save
  silent execute "!git diff"
  redir END
  " Different between matchstr vs match ??
  if !empty(matchstr(g:output_save,"diff --"))
    exe "silent! Git stash save -u"
    exe "silent! Git checkout " . rev
    exe "silent! edit"
  else
    exe "silent! Git checkout " . rev
  endif
  nnoremap <buffer> q :call LoadPreviousBranch()<cr>
endfunction


let g:clap#provider#preview# = s:preview

let &cpoptions = s:save_cpo
unlet s:save_cpo

