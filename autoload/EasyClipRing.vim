set encoding=utf-8 nobomb
scriptencoding UTF-8

" ============================================================================
" EasyClipRing.vim v1.1.0
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

" ============================================================================
" Private vars
" ============================================================================

let s:ecr_in_complete   = 1

let s:ecr_original_pum_height = &pumheight
let s:ecr_max_pum_height = 10
let s:ecr_max_pum_width = 40

" ============================================================================
" PUM and completion insertion settings
" ============================================================================

function! s:CompleteSetup()
  let s:saveformatoptions = &formatoptions
  set formatoptions-=c
  execute 'set pumheight=' . s:ecr_max_pum_height
endfunction

function! s:CompleteTeardown()
  let &formatoptions = s:saveformatoptions
  execute 'set pumheight=' . s:ecr_original_pum_height
endfunction

" ============================================================================
" Clean nulls from EasyClip completion result
" ============================================================================

function! s:CleanNulls()
  if !s:ecr_in_complete | return | endif
  let s:ecr_in_complete = 0

  if exists('v:completed_item') && !empty(v:completed_item)
    " @TODO fix copying multiline comments
    execute 's/\%x00/\r/ge'
  endif

  call s:CompleteTeardown()
endfunction

augroup EasyClipRing
  autocmd!
  autocmd CompleteDone * call s:CleanNulls()
augroup END

" ============================================================================
" Create completion dictionary
" ============================================================================

function! s:YanksToArray()
  let yanks_array = []
  for yank in EasyClip#Yank#EasyClipGetAllYanks()
    let text = yank.text
    let key = len(text) > s:ecr_max_pum_width
          \ ? text[: s:ecr_max_pum_width] . '…'
          \ : text

    call add(yanks_array, {
          \   'abbr': key,
          \   'word': text
          \ })
  endfor

  return yanks_array
endfunction

" ============================================================================
" Trigger completion menu
" ============================================================================

function! EasyClipYankPum()
  " Requires EasyClip! Check here in case it was lazy-loaded
  if !exists('g:EasyClipYankHistorySize') | return | endif

  let s:ecr_in_complete = 1
  call s:CompleteSetup()
  call complete(col('.'), s:YanksToArray())
  return ''
endfunction

" ============================================================================
" Mapping
" Provide <Plug>(EasyClipRing)
" ============================================================================

inoremap <silent>   <Plug>(EasyClipRing)  <C-R>=EasyClipYankPum()<CR>

" ============================================================================
" Done
" ============================================================================

let &cpo= s:keepcpo
unlet s:keepcpo

