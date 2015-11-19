set encoding=utf-8 nobomb
scriptencoding UTF-8

" ============================================================================
" EasyClip ring
" Requires vim-easyclip installed
" Press <Leader>cr to get a pop-up menu to select a yank
" ============================================================================

let s:ecr_max_pum_width = 40

augroup EasyClipRing
  autocmd!
  autocmd CompleteDone * call s:CleanNulls()
augroup END

function! s:CleanNulls()
  if !s:ecr_in_complete | return | endif
  let s:ecr_in_complete = 0

  if !exists('v:completed_item') || empty(v:completed_item)
    return
  endif
endfunction



function! s:YanksToArray()
  let yanks_array = []
  for yank in EasyClip#Yank#EasyClipGetAllYanks()
      let text = yank.text " substitute(yank.text, '\n', '', 'g')
      let key = len(text) > s:ecr_max_pum_width
            \ ? text[: s:ecr_max_pum_width] . '…'
            \ : text

      call add(yanks_array, {
            \   'abbr': key,
            \   'word': printf('%s', text),
            \ })
  endfor

  return yanks_array
endfunction

function! EasyClipYankPum()
  let s:ecr_in_complete = 1
  call complete(col('.'), s:YanksToArray())
  return ''
endfunc

" key binding
inoremap <Leader>cr <C-R>=EasyClipYankPum()<CR>
