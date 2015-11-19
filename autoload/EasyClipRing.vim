scriptencoding UTF-8

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

function! EasyClipRing#CompleteSetup()
  let s:saveformatoptions = &formatoptions
  set formatoptions-=c
  execute 'set pumheight=' . s:ecr_max_pum_height
endfunction

function! EasyClipRing#CompleteTeardown()
  let &formatoptions = s:saveformatoptions
  execute 'set pumheight=' . s:ecr_original_pum_height
endfunction

" ============================================================================
" Clean nulls from EasyClip completion result
" ============================================================================

function! EasyClipRing#CleanNulls()
  if !s:ecr_in_complete | return | endif
  let s:ecr_in_complete = 0

  if exists('v:completed_item') && !empty(v:completed_item)
    execute 's/\%x00/\r/ge'
  endif

  call EasyClipRing#CompleteTeardown()
endfunction

" ============================================================================
" Create completion dictionary
" ============================================================================

function! EasyClipRing#YanksToArray()
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

function! EasyClipRing#TriggerPum()
  " Requires EasyClip! Check here in case it was lazy-loaded
  if !exists('g:EasyClipYankHistorySize') | return | endif

  let s:ecr_in_complete = 1
  call EasyClipRing#CompleteSetup()
  call complete(col('.'), EasyClipRing#YanksToArray())
  return ''
endfunction


