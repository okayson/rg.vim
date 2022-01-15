" How to test
" 1. Open this file
" 2. Source this file. 
"   :so %
" 3. Type command, 'TestXxx'
"
" Multiple matching
function s:test_multi_search() "{{{
	" AAA
	" BBB
	Rg! 'AAA|BBB'
endfunction
command! TestMulti call <SID>test_multi_search()
"}}}
function s:test_multi_search2() "{{{
	" CCC
	" DDD
	Rg! -e 'CCC' -e 'DDD'
endfunction
command! TestMulti2 call <SID>test_multi_search2()
"}}}

" Highlighting
" Highlighting-Try
function s:make_highlight_target(args) "{{{

  let l:args = a:args
  echo 'original ... ' . string(l:args)
  let l:args = substitute(l:args, "'", '', 'g')
  let l:args = substitute(l:args, '"', '', 'g')
  let l:args = substitute(l:args, '|', ' ', 'g')
  let l:args_list = split(l:args)
  let l:args_list_f = filter(copy(l:args_list), 'v:val !~ "-"')
  call filter(l:args_list_f, '!isdirectory(v:val)')
  call filter(l:args_list_f, '!filereadable(v:val)')
  echo 'result ..... ' . string(l:args_list_f)

  return escape(join(l:args_list_f,'|'), '|')

endfunction "}}}
function s:try_highlight_string1() "{{{

  "TRY: Multiplu keyword
  let l:args = "-i --hidden -e 'XXX' -e \"YYY\""
  let l:target = s:make_highlight_target(l:args)
  echo l:target
  let @/ = l:target
  call feedkeys(":let &hlsearch=1\<CR>", 'n')

endfunction
command! TryHighlightString1 call <SID>try_highlight_string1()
"}}}
function s:try_highlight_string2() "{{{
  "TRY: Specifying '|'

  " let l:args = "-i --hidden -e 'XXX' -e \"YYY|ZZZ\""
  let l:args = "-i --hidden -e 'XXX' -e \"YYY | ZZZ\""
  let l:target = s:make_highlight_target(l:args)
  echo l:target
  let @/ = l:target
  call feedkeys(":let &hlsearch=1\<CR>", 'n')

endfunction
command! TryHighlightString2 call <SID>try_highlight_string2()
"}}}
function s:try_highlight_string3() "{{{
  "TRY: Specifying directory and no-highlighting it.
  let l:this_dir  = expand('%:h') "Test
  let l:bashrc_dir  = $HOME
  echo l:this_dir    ' ... ' . string(isdirectory(l:this_dir))
  echo l:bashrc_dir  ' ... ' . string(isdirectory(l:bashrc_dir))

  let l:args = "-i --hidden -e 'XXX' -e \"YYY | ZZZ\" " . l:this_dir
  let l:target = s:make_highlight_target(l:args)
  echo l:target
  let @/ = l:target
  call feedkeys(":let &hlsearch=1\<CR>", 'n')

endfunction
command! TryHighlightString3 call <SID>try_highlight_string3()
"}}}
function s:try_highlight_string4() "{{{
  "TRY: Specifying file and no-highlighting it.
  let l:this_file = expand('%')   "Test/test.vim
  let l:bashrc_file = $HOME . '/.bashrc'
  echo l:this_file   ' ... ' . string(filereadable(l:this_file))
  echo l:bashrc_file ' ... ' . string(filereadable(l:bashrc_file))

  let l:args = "-i --hidden -e 'XXX' -e \"YYY | ZZZ\" " . l:this_file
  let l:target = s:make_highlight_target(l:args)
  echo l:target
  let @/ = l:target
  call feedkeys(":let &hlsearch=1\<CR>", 'n')
endfunction
command! TryHighlightString4 call <SID>try_highlight_string4()
"}}}
" Highlighting-Test
function s:test_highlight1() "{{{

  if exists('g:rg_highlight')
    let l:save_rg_highlight = g:rg_highlight
  else
    let l:save_rg_highlight = 0
  endif
  let g:rg_highlight = 1

  let l:this_file = expand('%')   "Test/test.vim
  silent! execute "Rg! -i --hidden -e 'XXX' -e \"YYY | ZZZ\" " . l:this_file

  g:rg_highlight = l:save_rg_highlight
endfunction
command! TestHighlight1 call <SID>test_highlight1()
"}}}

" Option definition by dict
function s:set_default_dictvalue(dict, key, value) "{{{
  if !has_key(a:dict, a:key)
    " let a:dict.a:key = a:value
    let a:dict[a:key] = a:value
  endif
endfunction
"}}}
function s:test_opt_def() "{{{

  echo '# Test - Add undefined option'
  let l:rg = {}
  call s:set_default_dictvalue(l:rg, 'command', 'rg')
  echo l:rg

  echo '# Test - Ignore defined option'
  let l:rg = {}
  let l:rg['command'] = 'rg2'
  call s:set_default_dictvalue(l:rg, 'command', 'rg')
  echo l:rg

  echo '# Test - Add included dict'
  let l:rg = {}
  call s:set_default_dictvalue(l:rg, 'qflist', {})
  call s:set_default_dictvalue(l:rg.qflist, 'open', 1)
  call s:set_default_dictvalue(l:rg.qflist, 'position', 'botright')
  call s:set_default_dictvalue(l:rg.qflist, 'height', '10')
  echo l:rg

  echo '# Test - Ignore defined option in included dict'
  let l:rg = {}
  let l:rg = {
        \ 'command': 'rg2',
        \ 'qflist': { 'open': 0 }
        \}
  call s:set_default_dictvalue(l:rg, 'command', 'rg')
  call s:set_default_dictvalue(l:rg, 'qflist', {})
  call s:set_default_dictvalue(l:rg.qflist, 'open', 1)
  call s:set_default_dictvalue(l:rg.qflist, 'position', 'botright')
  call s:set_default_dictvalue(l:rg.qflist, 'height', '10')
  echo l:rg

  " echo '# Test - template'
  " let l:rg = {}
  " echo l:rg

endfunction
command! TestOptDef call <SID>test_opt_def()
"}}}
function s:test_opt_def2() "{{{

  echo '# Test - Set Default Values'
  let l:rg = {}
  call s:set_default_dictvalue(l:rg, 'command', 'rg')
  call s:set_default_dictvalue(l:rg, 'options', '')
  call s:set_default_dictvalue(l:rg, 'format', '%f:%l:%c:%m')
  call s:set_default_dictvalue(l:rg, 'follow_case_setting', 1)
  call s:set_default_dictvalue(l:rg, 'highlight', 0)
  call s:set_default_dictvalue(l:rg, 'qflist', {})
  call s:set_default_dictvalue(l:rg.qflist, 'open', 1)
  call s:set_default_dictvalue(l:rg.qflist, 'position', 'botright')
  call s:set_default_dictvalue(l:rg.qflist, 'height', '')
  call s:set_default_dictvalue(l:rg, 'loclist', {})
  call s:set_default_dictvalue(l:rg.loclist, 'open', 1)
  call s:set_default_dictvalue(l:rg.loclist, 'position', 'botright')
  call s:set_default_dictvalue(l:rg.loclist, 'height', '')
  echo l:rg

endfunction

command! TestOptDef2 call <SID>test_opt_def2()
"}}}

" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et
