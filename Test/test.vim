
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


" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et
