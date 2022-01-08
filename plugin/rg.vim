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

nnoremap <Plug>(rg-rg)                :<C-u>Rg<Space>
nnoremap <Plug>(rg-rgadd)             :<C-u>RgAdd<Space>
nnoremap <Plug>(rg-lrg)               :<C-u>LRg<Space>
nnoremap <Plug>(rg-lrgadd)            :<C-u>LRgAdd<Space>
nnoremap <Plug>(rg-rg-cur-word)       :<C-u>Rg<CR>
nnoremap <Plug>(rg-rgadd-cur-word)    :<C-u>RgAdd<CR>
nnoremap <Plug>(rg-lrg-cur-word)      :<C-u>LRg<CR>
nnoremap <Plug>(rg-lrgadd-cur-word)   :<C-u>LRgAdd<CR>
nnoremap <Plug>(rg-lrgadd-cur-word)   :<C-u>LRgAdd<CR>

" -------------------------------------------------
let &cpo = s:save_cpo
unlet s:save_cpo
" -------------------------------------------------
" vim: ft=vim fdm=marker sw=2 sts=2 ts=2 et
