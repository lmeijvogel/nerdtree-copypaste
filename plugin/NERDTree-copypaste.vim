" ============================================================================
" File:        NERDTree-copypaste.vim
" Description: Adds cut/copy/paste files/dirs to NERD_Tree
" Maintainer:  Lennaert Meijvogel <l.meijvogel@yahoo.co.uk>
" License:     MIT
" ============================================================================

if exists("g:loaded_nerdtree_copypaste")
  finish
endif

let g:loaded_nerdtree_copypaste = 1
let s:cut_file_or_dir = ''
let s:cut_or_copy = ''

" add the new menu item via NERD_Tree's API
call NERDTreeAddMenuItem({
  \ 'text': 'cut file (x)',
  \ 'shortcut': 'x',
  \ 'callback': 'NERDTreeCutFile' })

call NERDTreeAddMenuItem({
  \ 'text': 'copy file (x)',
  \ 'shortcut': 'x',
  \ 'callback': 'NERDTreeCopyFile' })

call NERDTreeAddMenuItem({
  \ 'text': '(p)aste file',
  \ 'shortcut': 'p',
  \ 'callback': 'NERDTreePasteFile' })

function! NERDTreeCutFile()
  let s:cut_file_or_dir = g:NERDTreeFileNode.GetSelected().path.str()
  let s:cut_or_copy = 'cut'
endfunction

function! NERDTreeCopyFile()
  let s:cut_file_or_dir = g:NERDTreeFileNode.GetSelected().path.str()
  let s:cut_or_copy = 'copy'
endfunction

function! NERDTreePasteFile()
  if s:cut_file_or_dir == ''
    echo "No file previously cut or copied"
  else
    let paste_dir = g:NERDTreeDirNode.GetSelected().path.str()
    let source_basename = split(s:cut_file_or_dir, "/")[-1]
    let destination_name = paste_dir."/".source_basename

    let exists = filereadable(destination_name)

    let force_flag = '--no-clobber'

    if exists
      if NERDTreeGetConfirmation()
        let force_flag = '--force'
      endif
    endif

    if s:cut_or_copy == 'cut'
      exec '!mv '.force_flag.' "'.s:cut_file_or_dir.'" "'.paste_dir.'/"'

      let s:cut_file_or_dir = ''
      let s:cut_or_copy = ''
    elseif s:cut_or_copy == 'copy'
      exec 'silent !cp '.force_flag.' --recursive "'.s:cut_file_or_dir.'" "'.paste_dir.'/"'

      " Do not clear file reference, this allows copying a file to multiple locations
    endif

    " Reload NERDTree (no API command exists)
    normal R

    redraw!
  endif
endfunction

function! NERDTreeGetConfirmation()
  let response = input("File exists, overwrite? [yN] ")

  let confirmed = (response =~# "y")

  return confirmed
endfunction
