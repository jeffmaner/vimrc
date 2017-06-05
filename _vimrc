set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()

function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" Set location for swap files.
" I don't want these showing up on remote servers.
" set dir=$HOME\\Temp
set noswapfile

" Set location for backup files.
" I don't want these showing up on remoted servers, either.
" set bdir=$HOME\\Temp
set nobackup

set noundofile

" colorscheme darkblue
" colorscheme vc " 2008-04-30
syntax enable
set background=light
colorscheme solarized

set cc=80

"set guifont=lucida_console
set guifont=apl385_unicode:h10
set tabstop=2
set shiftwidth=2
set expandtab
set nu

" Start in Maximized window.
au GUIEnter * simalt ~x

" Cross-hairs for the cursor!
set cursorline cursorcolumn
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn

map <C-J> :wincmd j<CR>
map <C-K> :wincmd k<CR>
map <C-L> :wincmd l<CR>
map <C-H> :wincmd h<CR>

set go-=T

inoremap {  {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {} {}
inoremap "  ""<Left>
inoremap "" ""
inoremap (  ()<Left>
inoremap () ()
inoremap [  []<Left>
inoremap [] []

let mapleader = " "
nnoremap <leader>ev :new    $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

"" Surround with quotes.
nnoremap <leader>" viw<Esc>a"<Esc>bi"<Esc>lel

"" inoremap <F3> <CR>=strftime("%Y-%m-%d %H:%M")
inoremap @dts <c-r>=strftime("%Y-%m-%d %H:%M")<CR>
inoremap @ds  <c-r>=strftime("%Y-%m-%d")<CR>
inoremap @ts  <c-r>=strftime("%H:%M")<CR>

call pathogen#infect()

let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'  : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme'   : $HOME.'/.gosh_completions',
    \ 'cs'       : $HOME.'/cs.neocomplcache',
    \ 'hs'       : $HOME.'/hs.neocomplcache'
    \ }
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

