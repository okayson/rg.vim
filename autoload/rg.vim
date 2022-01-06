" -------------------------------------------------
let s:save_cpo = &cpo
set cpo&vim
" -------------------------------------------------

" Option Variables "{{{
if !exists('g:rg_command')
  let g:rg_command = 'rg'
endif
if !exists('g:rg_options')
  let g:rg_options = ''
endif
if !exists('g:rg_format')
  let g:rg_format = "%f:%l:%c:%m"
endif
if !exists('g:rg_follow_case_setting')
  let g:rg_follow_case_setting = 1
endif
if !exists('g:rg_highlight')
  let g:rg_highlight = 0
endif
if !exists('g:rg_qflist_open')
  let g:rg_qflist_open = 1
endif
if !exists('g:rg_qflist_position')
  let g:rg_qflist_position = ''
  "let g:rg_qflist_position = 'botright'
endif
if !exists('g:rg_qflist_height')
  let g:rg_qflist_height = ''
endif
if !exists('g:rg_loclist_open')
  let g:rg_loclist_open = 1
endif
if !exists('g:rg_loclist_position')
  let g:rg_loclist_position = ''
  "let g:rg_loclist_position = 'botright'
endif
if !exists('g:rg_loclist_height')
  let g:rg_loclist_height = ''
endif
"}}}

function! rg#rg(bang, args) "{{{
  call rg#invoke_grep('grep', a:bang, a:args)
endfunction "}}}

function! rg#rgadd(bang, args) "{{{
  call rg#invoke_grep('grepadd', a:bang, a:args)
endfunction "}}}

function! rg#lrg(bang, args) "{{{
  call rg#invoke_grep('lgrep', a:bang, a:args)
endfunction "}}}

function! rg#lrgadd(bang, args) "{{{
  call rg#invoke_grep('lgrepadd', a:bang, a:args)
endfunction "}}}

function! rg#opts() "{{{
  echo rg#make_options()
endfunction "}}}

function! rg#invoke_grep(grep_type, bang, args) "{{{

  if !executable('rg')
    echohl WarningMsg
    echomsg "'rg' is not found."
    echohl None
    return
  endif

  let l:grep_command = rg#make_grep_command(a:grep_type, a:bang, a:args)
  if len(l:grep_command) == 0
    echohl WarningMsg
    echomsg 'Usage: Rg [options] {pattern} [{directory|file}]'
    echohl None
    return
  endif

  let l:save_grepprg = &grepprg
  let l:save_grepformat = &grepformat
  let l:save_t_ti = &t_ti
  let l:save_t_te = &t_te

  let &grepprg=g:rg_command
  let &grepformat=g:rg_format
  set t_ti=
  set t_te=

  silent! execute l:grep_command

  let &grepprg=l:save_grepprg
  let &grepformat=l:save_grepformat
  let &t_ti=l:save_t_ti
  let &t_te=l:save_t_te

  call rg#update_view(a:grep_type, a:args)

endfunction "}}}

function! rg#make_options() "{{{

  let l:options = []
  call add(l:options, g:rg_options)
  call add(l:options, rg#make_case_options())
  return join(l:options)

endfunction "}}}

function! rg#make_case_options() "{{{
  let l:case_options = []

  if g:rg_follow_case_setting == 1
    if &ignorecase == 1
      call add(l:case_options, '--ignore-case')
    endif
    if &smartcase == 1
      call add(l:case_options, '--smart-case')
    endif
  endif

  return join(l:case_options)
endfunction "}}}

function! rg#make_grep_command(grep_type, bang, args) "{{{

  let l:args = a:args
  if empty(l:args)
    let l:args = expand("<cword>")
  end

  if empty(l:args)
    return ''
  endif

  let l:grep_command = []
  call add(l:grep_command, a:grep_type . a:bang)
  call add(l:grep_command, '--vimgrep')
  call add(l:grep_command, rg#make_options())
  call add(l:grep_command, l:args)

  return join(l:grep_command)

endfunction "}}}

function! rg#update_view(grep_type, args) "{{{

  " open result list
  if a:grep_type =~# '^l'
    let l:matched_count = len(getloclist(winnr()))
    let l:list_open_command = ((g:rg_loclist_open == 1) ? (g:rg_loclist_position . ' lopen ' . g:rg_loclist_height) : '')
  else
    let l:matched_count = len(getqflist())
    let l:list_open_command = ((g:rg_qflist_open == 1)  ? (g:rg_qflist_position  . ' copen ' . g:rg_qflist_height)  : '')
  endif

  if l:matched_count && len(l:list_open_command)
    silent! execute l:list_open_command
  endif

  " highlight
  if g:rg_highlight == 1
    "TODO: 
    echohl ErrorMsg
    echomsg "'g:rg_highlight' is not implemented now."
    echohl None
  end

  redraw!

  if l:matched_count == 0
    echohl WarningMsg
    echomsg 'No matched.'
    echohl None
  endif

endfunction "}}}
" -------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
" -------------------------------------------------

" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et