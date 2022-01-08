" -------------------------------------------------
if exists('g:loaded_rg')
	finish
endif
let g:loaded_rg = 1

let s:save_cpo = &cpo
set cpo&vim
" -------------------------------------------------

command! -bang -nargs=* -complete=file Rg     call rg#rg('<bang>',<q-args>)
command! -bang -nargs=* -complete=file RgAdd  call rg#rgadd('<bang>', <q-args>)
command! -bang -nargs=* -complete=file LRg    call rg#lrg('<bang>', <q-args>)
command! -bang -nargs=* -complete=file LRgAdd call rg#lrg('<bang>', <q-args>)

command! -nargs=0 RgShowConfig call rg#show_config()
command! -nargs=0 RgShowImplicitOpts call rg#show_implicit_opts()
command! -nargs=1 RgFollowCaseSetting call rg#follow_case_setting(<q-args>)

" -------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
" -------------------------------------------------
" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et
