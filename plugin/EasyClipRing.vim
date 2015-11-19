scriptencoding UTF-8

" ============================================================================
" EasyClipRing.vim v1.2.1
" ----------------------------------------------------------------------------
" Author:   David O'Trakoun <me@davidosomething.com>
" Homepage: http://github.com/davidosomething/EasyClipRing.vim
" ----------------------------------------------------------------------------
" Provides an pum completion for EasyClip yanks.
" Requires vim-easyclip installed.
" ============================================================================

" ============================================================================
" Bootstrap plugin
" ============================================================================

if exists('g:loaded_EasyClipRing') | finish | endif
let g:loaded_EasyClipRing = 1
let s:keepcpo = &cpo
set cpo&vim

augroup EasyClipRing
  autocmd!
  autocmd CompleteDone * call EasyClipRing#CleanNulls()
augroup END

" ============================================================================
" Mapping
" Provide <Plug>(EasyClipRing)
" ============================================================================

inoremap <unique><script> <Plug>(EasyClipRing) <C-R>=EasyClipRing#TriggerPum()<CR>

" ============================================================================
" Done
" ============================================================================

let &cpo= s:keepcpo
unlet s:keepcpo

