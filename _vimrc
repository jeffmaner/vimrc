"" http://learnvimscriptthehardway.stevelosh.com/ was an excellent source.

"" Example vimrc Content {{{
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
"" Example vimrc Content }}}

"" Swap, Backup, and Undo Files {{{
" Set location for swap files.
" I don't want these showing up on remote servers.
" set dir=$HOME\\Temp
set noswapfile

" Set location for backup files.
" I don't want these showing up on remoted servers, either.
" set bdir=$HOME\\Temp
set nobackup

set noundofile
"" Swap, Backup, and Undo Files }}}

"" General Settings {{{
" colorscheme darkblue
" colorscheme vc " 2008-04-30
syntax enable
set background=light
colorscheme solarized

set cc=80 "" colorcolumn
highlight colorcolumn ctermbg=lightred guibg=lightred

"set guifont=lucida_console
set guifont=apl385_unicode:h10
set tabstop=2
set shiftwidth=2
set expandtab
set number
set foldlevelstart=0
"" General Settings }}}

" Start in Maximized window.
autocmd GUIEnter * simalt ~x

" Cross-hairs for the cursor!
set cursorline cursorcolumn
augroup crosshairs
  autocmd WinLeave * set nocursorline nocursorcolumn
  autocmd WinEnter * set cursorline cursorcolumn
augroup end

"" Window Commands {{{
map <C-J> :wincmd j<CR>
map <C-K> :wincmd k<CR>
map <C-L> :wincmd l<CR>
map <C-H> :wincmd h<CR>
"" Window Commands }}}

set go-=T

"" Mappings {{{
let mapleader = " "

"" Bracket and Quote Auto-close {{{
inoremap {  {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {} {}
inoremap "  ""<Left>
inoremap "" ""
inoremap (  ()<Left>
inoremap () ()
inoremap [  []<Left>
inoremap [] []
"" Bracket and Quote Auto-close }}}

nnoremap <leader>ev :new    $HOME/Documents/GitHub/vimrc/_vimrc<CR>
nnoremap <leader>sv :source $HOME/Documents/GitHub/vimrc/_vimrc<CR>

"" Use no magic.
nnoremap / /\v

"" Bracket and Quote Manipulation {{{
"" Surround with quotes.
nnoremap <leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <leader>" c""<Esc>Pl
"" Surround with parentheses.
nnoremap <leader>( viw<Esc>a)<Esc>bi(<Esc>lel
vnoremap <leader>( c()<Esc>Pl
"" Surround with square brackets.
nnoremap <leader>[ viw<Esc>a]<Esc>bi[<Esc>lel
vnoremap <leader>[ c[]<Esc>Pl
"" Surround with curly brackets.
nnoremap <leader>{ viw<Esc>a}<Esc>bi{<Esc>lel
vnoremap <leader>{ c{}<Esc>Pl
"" Bracket and Quote Manipulation }}}

"" Split Line on Commas.
nnoremap <leader>sc :s/\s*,\s*/\r/g<cr>
"" Split Line on Semicolons.
nnoremap <leader>sc :s/\s*;\s*/\r/g<cr>

"" Move line down.
nnoremap - ddp
"" Move line up. TODO: Using this on the last line in the file will move up
"" two lines. And using this on the first line in the file will simply lose
"" lines.
nnoremap _ ddkP

"" Date and Time Mappings {{{
inoremap @dts <c-r>=strftime("%Y-%m-%d %H:%M")<CR>
inoremap @ds  <c-r>=strftime("%Y-%m-%d")<CR>
inoremap @ts  <c-r>=strftime("%H:%M")<CR>
"" Date and Time Mappings }}}

"" TODO: Replace this mapping with an abbreviation getset?
inoremap @gs { get; set; }
"" Mappings }}}

call pathogen#infect()

"" neocomplcache {{{
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
"" neocomplcache }}}

" Vimscript File Settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup end
" Vimscript File Settings }}}
