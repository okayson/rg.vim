" -------------------------------------------------
let s:save_cpo = &cpo
set cpo&vim
" -------------------------------------------------

function! s:configure() "{{{
  if !exists('g:rg_config')
    let g:rg_config = {}
  endif

  call s:set_default_dictvalue(g:rg_config, 'command', 'rg')
  call s:set_default_dictvalue(g:rg_config, 'options', '')
  call s:set_default_dictvalue(g:rg_config, 'format', '%f:%l:%c:%m')
  call s:set_default_dictvalue(g:rg_config, 'follow_case_setting', 1)
  call s:set_default_dictvalue(g:rg_config, 'highlight', 1)
  call s:set_default_dictvalue(g:rg_config, 'qflist', {})
  call s:set_default_dictvalue(g:rg_config.qflist, 'open', 1)
  call s:set_default_dictvalue(g:rg_config.qflist, 'position', 'botright')
  call s:set_default_dictvalue(g:rg_config.qflist, 'height', '')
  call s:set_default_dictvalue(g:rg_config, 'loclist', {})
  call s:set_default_dictvalue(g:rg_config.loclist, 'open', 1)
  call s:set_default_dictvalue(g:rg_config.loclist, 'position', 'botright')
  call s:set_default_dictvalue(g:rg_config.loclist, 'height', '')
endfunction
"}}}

function s:set_default_dictvalue(dict, key, value) "{{{
  if !has_key(a:dict, a:key)
    let a:dict[a:key] = a:value
  endif
endfunction
"}}}

" Set up configurations
call s:configure()

function! rg#rg(bang, args) "{{{
  call s:invoke_grep('grep', a:bang, a:args)
endfunction "}}}

function! rg#rgadd(bang, args) "{{{
  call s:invoke_grep('grepadd', a:bang, a:args)
endfunction "}}}

function! rg#lrg(bang, args) "{{{
  call s:invoke_grep('lgrep', a:bang, a:args)
endfunction "}}}

function! rg#lrgadd(bang, args) "{{{
  call s:invoke_grep('lgrepadd', a:bang, a:args)
endfunction "}}}

function! s:invoke_grep(grep_type, bang, args) "{{{

  if !executable('rg')
    echohl WarningMsg
    echomsg "'rg' is not found."
    echohl None
    return
  endif

  let l:grep_command = s:make_grep_command(a:grep_type, a:bang, a:args)
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

  let &grepprg=g:rg_config.command
  let &grepformat=g:rg_config.format
  set t_ti=
  set t_te=

  silent! execute l:grep_command

  let &grepprg=l:save_grepprg
  let &grepformat=l:save_grepformat
  let &t_ti=l:save_t_ti
  let &t_te=l:save_t_te

  call s:update_view(a:grep_type, a:args)

endfunction "}}}

function! s:make_options() "{{{

  let l:options = []
  call add(l:options, g:rg_config.options)
  call add(l:options, s:make_case_options())
  return join(l:options)

endfunction "}}}

function! s:make_case_options() "{{{
  let l:case_options = []

  if g:rg_config.follow_case_setting == 1
    if &ignorecase == 1
      call add(l:case_options, '--ignore-case')
    endif
    if &smartcase == 1
      call add(l:case_options, '--smart-case')
    endif
  endif

  return join(l:case_options)
endfunction "}}}

function! s:make_grep_command(grep_type, bang, args) "{{{

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
  call add(l:grep_command, s:make_options())
  call add(l:grep_command, l:args)

  return escape(join(l:grep_command), '|')

endfunction "}}}

function! s:update_view(grep_type, args) "{{{

  let l:matched_count = s:open_result_list(a:grep_type)

  redraw!

  if l:matched_count != 0
    call s:highlight_keyword(a:args)
  else
    echohl WarningMsg
    echomsg 'No matched.'
    echohl None
  endif

endfunction "}}}

function! s:open_result_list(grep_type) "{{{

  if a:grep_type =~# '^l'
    let l:matched_count = len(getloclist(winnr()))
    let l:list_open_command = ((g:rg_config.loclist.open == 1) ? 
          \(g:rg_config.loclist.position . ' lopen ' . g:rg_config.loclist.height) : '')
  else
    let l:matched_count = len(getqflist())
    let l:list_open_command = ((g:rg_config.qflist.open == 1)  ? 
          \(g:rg_config.qflist.position  . ' copen ' . g:rg_config.qflist.height)  : '')
  endif

  if l:matched_count && len(l:list_open_command)
    silent! execute l:list_open_command
  endif

  return l:matched_count

endfunction "}}}

function! s:highlight_keyword(args) "{{{

  if g:rg_config.highlight != 1
    return
  end

  let l:args = a:args
  let l:args = substitute(l:args, "'", '', 'g')
  let l:args = substitute(l:args, '"', '', 'g')
  let l:args = substitute(l:args, '|', ' ', 'g')
  let l:args_list = split(l:args)
  call filter(l:args_list, 'v:val !~ "-"')
  call filter(l:args_list, '!isdirectory(v:val)')
  call filter(l:args_list, '!filereadable(v:val)')

  let @/ = escape(join(l:args_list,'|'), '|')
  call feedkeys(":let &hlsearch=1 \| echo \<CR>", 'n')

endfunction "}}}

function! rg#show_config() "{{{

  echo 'g:rg_config.command              : ' . g:rg_config.command
  echo 'g:rg_config.options              : ' . g:rg_config.options
  echo 'g:rg_config.format               : ' . g:rg_config.format
  echo 'g:rg_config.follow_case_setting  : ' . g:rg_config.follow_case_setting
  echo 'g:rg_config.highlight            : ' . g:rg_config.highlight
  echo 'g:rg_config.qflist.open          : ' . g:rg_config.qflist.open
  echo 'g:rg_config.qflist.position      : ' . g:rg_config.qflist.position
  echo 'g:rg_config.qflist.height        : ' . g:rg_config.qflist.height
  echo 'g:rg_config.loclist.open         : ' . g:rg_config.loclist.open
  echo 'g:rg_config.loclist.position     : ' . g:rg_config.loclist.position
  echo 'g:rg_config.loclist.height       : ' . g:rg_config.loclist.height

endfunction "}}}

function! rg#show_implicit_opts() "{{{
  echo s:make_options()
endfunction "}}}

function! rg#follow_case_setting(enabled) "{{{
  let g:rg_config['follow_case_setting'] = a:enabled
  echo 'g:rg_config.follow_case_setting is set to ' . a:enabled
endfunction "}}}

" -------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
" -------------------------------------------------

" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et
