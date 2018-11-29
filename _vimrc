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
set hlsearch
set incsearch
"" General Settings }}}

" Start in Maximized window.
if has("win32") || has("win16")
  autocmd GUIEnter * simalt ~x
else
  autocmd GUIEnter * call system('wmctrl -i -b add,maximized_vert,maximized_horz -r'.v:windowid)
endif

" Cross-hairs for the cursor!
set cursorline cursorcolumn
augroup crosshairs
  autocmd WinLeave * set nocursorline nocursorcolumn
  autocmd WinEnter * set cursorline cursorcolumn
augroup end

"" Trailing Whitespace Highlighting {{{
"" https://superuser.com/questions/921920/display-trailing-spaces-in-vim
"" Comments on answer are helpful, but I'm not sure how to implement them.
highlight ExtraWhitespace ctermbg=red guibg=red
let m = matchadd("ExtraWhitespace", "/\s\+$/")
autocmd BufWinEnter * let m = matchadd("ExtraWhitespace", "/\s\+$/")
autocmd InsertEnter * let m = matchadd("ExtraWhitespace", "/\s\+\%#\@<!$/")
autocmd InsertLeave * let m = matchadd("ExtraWhitespace", "/\s\+$/")
""autocmd BufWinLeave * call matchdelete(m) "" Raises errors.
"" Trailing Whitespace Highlighting }}}

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

"" Split Line on Commas.
nnoremap <leader>sc :s/\s*,\s*/\r/g<cr>
"" Split Line on Semicolons.
nnoremap <leader>ss :s/\s*;\s*/\r/g<cr>
"" Trim trailing whitespace.
nnoremap <leader>tw :%s/\v\s+$//g<cr>
"" Detab (convert tabs into two spaces apiece).
nnoremap <leader>dt :%s/\t/  /g<cr>
"" Clean stack trace.
nnoremap <leader>cst :%s/\sat\>/\rat/g<cr>
"" De-yell SQL.
nnoremap <leader>dys :%call DeYellSQL()<cr>
"" Clear highlighting.
nnoremap <c-n> :noh<cr>
"" Easier writing.
nnoremap <leader>w :w<cr>

"" Visual Search.
vmap X y/<C-R>"<cr>

"" Date and Time Mappings {{{
inoremap @dts <c-r>=strftime("%Y-%m-%d %H:%M")<CR>
inoremap @ds  <c-r>=strftime("%Y-%m-%d")<CR>
inoremap @ts  <c-r>=strftime("%H:%M")<CR>
"" Date and Time Mappings }}}
"" Mappings }}}

"" Macros {{{
"" My SQL clean-up:
let @s = ':%call DeYellSQL()
'
"" Macros }}}

"" Abbreviations {{{
iabbrev getset { get; set; }
"" }}}

"" Functions {{{
function! DeYellSQL() range
  let keywords  = []
  let keywords += [ 'abs', 'all', 'alter', 'and', 'ansi_nulls', 'as', 'asc', ]
  let keywords += [ 'begin', 'between', 'by', ]
  let keywords += [ 'case', 'cast', 'catch', 'close', 'commit', 'convert', 'count', 'create', 'cursor', ]
  let keywords += [ 'dateadd', 'datediff', 'datetime', 'deallocate', 'decimal', 'declare', 'delete', 'desc', 'distinct', ]
  let keywords += [ 'else', 'end', 'error_message', 'error_severity', 'error_state', 'exec', 'exists', ]
  let keywords += [ 'fetch', 'fetch_status', 'for', 'from', ]
  let keywords += [ 'getdate', 'go', 'group', ]
  let keywords += [ 'having', ]
  let keywords += [ 'if', 'in', 'inner', 'insert', 'int', 'into', 'is', 'isnull', 'isnumeric', ]
  let keywords += [ 'join', ]
  let keywords += [ 'left', 'len', 'local', 'ltrim', ]
  let keywords += [ 'max', 'min', 'money', ]
  let keywords += [ 'next', 'nocount', 'nolock', 'not', 'null', 'numeric', 'nvarchar', ]
  let keywords += [ 'on', 'open', 'or', 'order', 'outer', 'over', ]
  let keywords += [ 'partition', 'procedure', ]
  let keywords += [ 'quoted_identifier' ]
  let keywords += [ 'raiserror', 'replace', 'right', 'rollback', 'round', 'row_number', 'rowcount', 'rtrim', ]
  let keywords += [ 'select', 'set', 'substring', 'sum', ]
  let keywords += [ 'table', 'then', 'top', 'tran', 'transaction', 'truncate', 'try', ]
  let keywords += [ 'union', 'update', 'use', ]
  let keywords += [ 'values', 'varchar', 'when', ]
  let keywords += [ 'where', 'while', 'with' ] 

  for w in keywords
    let pattern = '\c\<' . w . '\>'
    execute "%substitute/" . pattern . "/". w . "/eg"
  endfor

  "" TODO: None of the following work. I don't know why.
  "" Replace <> with != becuase I like != better than <>.
  execute "%substitute/<>/!=/eg"
  "" Ensure equal signs are surrounded by space.
  execute "%substitute/\([!<>=\s]\)=\([=\s]\)/\1 = \2/eg"
  "" Ensure commas are followed by space.
  execute "%substitute/,\(\S\)/, \1/eg"
  "" Get rid of superfluous identifier brackets, then add them back where
  "" actually necessary.
  execute "normal! :%substitute/\[\|\]//eg"
  "" Add a space before comment text.
  execute "normal! :%substitute/(--)(\S)/\1 \2/eg"

  echo "DeYelled SQL."
endfunction

"" Inspired by Damian Conway at https://www.ibm.com/developerworks/library/l-vim-script-2/index.html
function! AlignAssignments()
    "" Patterns needed to locate assignment operators.
    let assignmentOperator = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let assignmentLine     = '^\(.\{-}\)\s*\(' . assignmentOperator . '\)'

    "" Locate block of code to be considered (same indentation, no blanks).
    let indentPattern = '^' . matchstr(getline('.'), '^\s*') . '\S'
    let firstLine     = search('^\%('. indentPattern . '\)\@!','bnW') + 1
    let lastLine      = search('^\%('. indentPattern . '\)\@!', 'nW') - 1
    if lastLine < 0
        let lastLine = line('$')
    endif

    "" Find the column at which the operators should be aligned.
    let maxAlignColumn   = 0
    let maxOperatorWidth = 0
    for lineText in getline(firstLine, lastLine)
        "" Does this line have an assignment in it?
        let leftWidth = match(lineText, '\s*' . assignmentOperator)

        "" If so, track the maximal assignment column and operator width.
        if leftWidth >= 0
            let maxAlignColumn   = max([maxAlignColumn, leftWidth])

            let operatorWidth    = strlen(matchstr(lineText, assignmentOperator))
            let maxOperatorWidth = max([maxOperatorWidth, operatorWidth + 1])
         endif
    endfor

    "" Code needed to reformat lines to align operators.
    let formatter = '\=printf("%-*s%*s", maxAlignColumn  , submatch(1),
    \                                    maxOperatorWidth, submatch(2))'

    "" Reformat lines with operators aligned in the appropriate column.
    for lineNumber in range(firstLine, lastLine)
        let oldLine = getline(lineNumber)
        let newLine = substitute(oldLine, assignmentLine, formatter, "")
        call setline(lineNumber, newLine)
    endfor
endfunction

nmap <silent> ;= :call AlignAssignments()<CR>
"" Functions }}}

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
