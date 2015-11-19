set encoding=utf-8 nobomb
scriptencoding UTF-8

" ============================================================================
" EasyClip ring
" Requires vim-easyclip installed
" Press <Leader>cr to get a pop-up menu to select a yank
" ============================================================================

" =============================================================================
" Bootstrap plugin
" =============================================================================

if exists('g:loaded_EasyClipRing') | finish | endif
let g:loaded_EasyClipRing = 1
let s:keepcpo = &cpo
set cpo&vim

" =============================================================================
" Private vars
" =============================================================================

let s:ecr_in_complete   = 1
let s:ecr_max_pum_width = 40

" =============================================================================
" Mapping
" =============================================================================

function! s:BindMappings()
  if exists('g:ecr_disable_default_mapping') && g:ecr_disable_default_mapping
    return
  endif

  " key binding
  inoremap <Leader>cr <C-R>=EasyClipYankPum()<CR>
endfunction

autocmd VimEnter * call s:BindMappings()
call s:BindMappings()

" =============================================================================
" Clean nulls from EasyClip completion result
" =============================================================================

function! s:CleanNulls()
  if !s:ecr_in_complete | return | endif
  let s:ecr_in_complete = 0

  if !exists('v:completed_item') || empty(v:completed_item)
    return
  endif

  execute 's/\%x00/\r/ge'
endfunction

augroup EasyClipRing
  autocmd!
  autocmd CompleteDone * call s:CleanNulls()
augroup END

" =============================================================================
" Create completion dictionary
" =============================================================================

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


" =============================================================================
" Trigger completion menu
" =============================================================================

function! EasyClipYankPum()
  let s:ecr_in_complete = 1
  call complete(col('.'), s:YanksToArray())
  return ''
endfunc

" =============================================================================
" Done
" =============================================================================

let &cpo= s:keepcpo
unlet s:keepcpo

