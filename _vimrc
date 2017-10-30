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

"" Trailing Whitespace Highlighting {{{
"" https://superuser.com/questions/921920/display-trailing-spaces-in-vim
"" Comments on answer are helpful, but I'm not sure how to implement them.
highlight ExtraWhitespace ctermbg=red guibg=red
let m = matchadd("ExtraWhitespace", "/\s\+$/")
autocmd BufWinEnter * let m = matchadd("ExtraWhitespace", "/\s\+$/")
autocmd InsertEnter * let m = matchadd("ExtraWhitespace", "/\s\+\%#\@<!$/")
autocmd InsertLeave * let m = matchadd("ExtraWhitespace", "/\s\+$/")
"" autocmd BufWinLeave * call matchdelete(m) "" Raises errors.
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

nnoremap <leader>ev :new    $HOME/Documents/GitHub/vimrc/_vimrc<cr>
nnoremap <leader>sv :source $HOME/Documents/GitHub/vimrc/_vimrc<cr>
nnoremap <leader>tw :%s/\v\s+$//g<cr>
nnoremap <leader>dt :%s/\t/  //g<cr>

"" Use no magic.
nnoremap / /\v

"" Bracket and Quote Manipulation {{{
"" Surround with single quotes.
nnoremap <leader>' viw<Esc>a'<Esc>bi'<Esc>lel
vnoremap <leader>' c''<Esc>Pl
"" Surround with double quotes.
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
nnoremap <leader>ss :s/\s*;\s*/\r/g<cr>

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

"" Macros {{{
"" My SQL clean-up:
let @s = ':%call DeYellSQL()'
"" Macros }}}

"" Functions {{{
function! DeYellSQL() range
  for lineNumber in range(a:firstline, a:lastline)
    let currentLine = getline(lineNumber)

    let currentLine = substitute(currentLine, '\c<\ASC\>'     , 'asc'         , 'g')
    let currentLine = substitute(currentLine, '\c<\DESC\>'    , 'desc'        , 'g')
    let currentLine = substitute(currentLine, '\cORDER'       , 'order'       , 'g')
    let currentLine = substitute(currentLine, '\c\<BY\>'      , 'by'          , 'g')
    let currentLine = substitute(currentLine, '\cCONVERT'     , 'convert'     , 'g')
    let currentLine = substitute(currentLine, '\cDELETE'      , 'delete'      , 'g')
    let currentLine = substitute(currentLine, '\cDECLARE'     , 'declare'     , 'g')
    let currentLine = substitute(currentLine, '\cDISTINCT'    , 'distinct'    , 'g')
    let currentLine = substitute(currentLine, '\c\<TABLE\>'   , 'table'       , 'g')
    let currentLine = substitute(currentLine, '\cINSERT'      , 'insert'      , 'g')
    let currentLine = substitute(currentLine, '\cINTO'        , 'into'        , 'g')
    let currentLine = substitute(currentLine, '\cSELECT'      , 'select'      , 'g')
    let currentLine = substitute(currentLine, '\cFROM'        , 'from'        , 'g')
    let currentLine = substitute(currentLine, '\cUNION'       , 'union'       , 'g')
    let currentLine = substitute(currentLine, '\c\<ALL\>'     , 'all'         , 'g')
    let currentLine = substitute(currentLine, '\cWHERE'       , 'where'       , 'g')
    let currentLine = substitute(currentLine, '\c\<AND\>'     , 'and'         , 'g')
    let currentLine = substitute(currentLine, '\c\<OR\>'      , 'or'          , 'g')
    let currentLine = substitute(currentLine, '\c\<IN\>'      , 'in'          , 'g')
    let currentLine = substitute(currentLine, '\c\<LEFT\>'    , 'left'        , 'g')
    let currentLine = substitute(currentLine, '\c\<RIGHT\>'   , 'right'       , 'g')
    let currentLine = substitute(currentLine, '\cINNER'       , ''            , 'g')
    let currentLine = substitute(currentLine, '\cOUTER'       , 'outer'       , 'g')
    let currentLine = substitute(currentLine, '\c\<JOIN\>'    , 'join'        , 'g')
    let currentLine = substitute(currentLine, '\c\<ON\>'      , 'on'          , 'g')
    let currentLine = substitute(currentLine, '\c\<IS\>'      , 'is'          , 'g')
    let currentLine = substitute(currentLine, '\c\<NOT\>'     , 'not'         , 'g')
    let currentLine = substitute(currentLine, '\c\<NULL\>'    , 'null'        , 'g')
    let currentLine = substitute(currentLine, '\cISNULL'      , 'isnull'      , 'g')
    let currentLine = substitute(currentLine, '\cEXISTS'      , 'exists'      , 'g')
    let currentLine = substitute(currentLine, '\c\<AS\>'      , 'as'          , 'g')
    let currentLine = substitute(currentLine, '\c\<INT\>'     , 'int'         , 'g')
    let currentLine = substitute(currentLine, '\cDECIMAL'     , 'decimal'     , 'g')
    let currentLine = substitute(currentLine, '\c\<CAST\>'    , 'cast'        , 'g')
    let currentLine = substitute(currentLine, '\cGETDATE'     , 'getdate'     , 'g')
    let currentLine = substitute(currentLine, '\cDATEADD'     , 'dateadd'     , 'g')
    let currentLine = substitute(currentLine, '\cLTRIM'       , 'ltrim'       , 'g')
    let currentLine = substitute(currentLine, '\cRTRIM'       , 'rtrim'       , 'g')
    let currentLine = substitute(currentLine, '\cUPDATE'      , 'update'      , 'g')
    let currentLine = substitute(currentLine, '\c\<SET\>'     , 'set'         , 'g')
    let currentLine = substitute(currentLine, '\c\<TOP\>'     , 'top'         , 'g')
    let currentLine = substitute(currentLine, '\cISNUMERIC'   , 'isnumeric'   , 'g')
    let currentLine = substitute(currentLine, '\cBETWEEN'     , 'between'     , 'g')
    let currentLine = substitute(currentLine, '\c\<COUNT\>'   , 'count'       , 'g')
    let currentLine = substitute(currentLine, '\c\<GROUP\>'   , 'group'       , 'g')
    let currentLine = substitute(currentLine, '\c\<ABS\>'     , 'abs'         , 'g')
    let currentLine = substitute(currentLine, '\c\<SUM\>'     , 'sum'         , 'g')
    let currentLine = substitute(currentLine, '\c\<ROUND\>'   , 'round'       , 'g')
    let currentLine = substitute(currentLine, '\c\<BEGIN\>'   , 'begin'       , 'g')
    let currentLine = substitute(currentLine, '\c\<END\>'     , 'end'         , 'g')
    let currentLine = substitute(currentLine, '\c\<WITH\>'    , 'with'        , 'g')
    let currentLine = substitute(currentLine, '\c\<EXEC\>'    , 'exec'        , 'g')
    let currentLine = substitute(currentLine, '\c\<DATEDIFF\>', 'datediff'    , 'g')
    let currentLine = substitute(currentLine, '\c\<NOLOCK\>'  , 'nolock'      , 'g')
    let currentLine = substitute(currentLine, '\c\<EXEC\>'    , 'exec'        , 'g')
    let currentLine = substitute(currentLine, '\c\<CASE\>'    , 'case'        , 'g')
    let currentLine = substitute(currentLine, '\c\<WHEN\>'    , 'when'        , 'g')
    let currentLine = substitute(currentLine, '\c\<THEN\>'    , 'then'        , 'g')
    let currentLine = substitute(currentLine, '\c\<ELSE\>'    , 'else'        , 'g')
    let currentLine = substitute(currentLine, '\c\<DATETIME\>', 'datetime'    , 'g')
    let currentLine = substitute(currentLine, '\c\<VARCHAR\>' , 'varchar'     , 'g')
    let currentLine = substitute(currentLine, '\c\<HAVING\>'  , 'having'      , 'g')
    let currentLine = substitute(currentLine, '\c\<MONEY\>'   , 'money'       , 'g')
    let currentLine = substitute(currentLine, '\c\<CURSOR\>'  , 'cursor'      , 'g')
    let currentLine = substitute(currentLine, '\c\<FOR\>'     , 'for'         , 'g')
    let currentLine = substitute(currentLine, '\c\<OPEN\>'    , 'open'        , 'g')
    let currentLine = substitute(currentLine, '\c\<FETCH\>'   , 'fetch'       , 'g')
    let currentLine = substitute(currentLine, '\c\<NEXT\>'    , 'next'        , 'g')
    let currentLine = substitute(currentLine, '\c\<WHILE\>'   , 'while'       , 'g')
    let currentLine = substitute(currentLine, '\c\<VALUES\>'  , 'values'      , 'g')
    let currentLine = substitute(currentLine, '\c\<CLOSE\>'   , 'close'       , 'g')
    let currentLine = substitute(currentLine, '\cDEALLOCATE'  , 'deallocate'  , 'g')
    let currentLine = substitute(currentLine, '\cFETCH_STATUS', 'fetch_status', 'g')
    let currentLine = substitute(currentLine, '\c\<IF\>'      , 'if'          , 'g')
    let currentLine = substitute(currentLine, '\c\<LOCAL\>'   , 'local'       , 'g')
    let currentLine = substitute(currentLine, '\c\<ROWCOUNT\>', 'rowcount'    , 'g')
    let currentLine = substitute(currentLine, '\cSUBSTRING'   , 'substring'   , 'g')
    let currentLine = substitute(currentLine, '\c\<LEN\>'     , 'len'         , 'g')
    let currentLine = substitute(currentLine, '\c\<USE\>'     , 'use'         , 'g')
    let currentLine = substitute(currentLine, '\c\<GO\>'      , 'go'          , 'g')
    let currentLine = substitute(currentLine, '\c\<ALTER\>'   , 'alter'       , 'g')
    let currentLine = substitute(currentLine, '\cPROCEDURE'   , 'procedure'   , 'g')
    let currentLine = substitute(currentLine, '\cTRANSACTION' , 'transaction' , 'g')
    let currentLine = substitute(currentLine, '\cCOMMIT'      , 'commit'      , 'g')
    let currentLine = substitute(currentLine, '\c\<MAX\>'     , 'max'         , 'g')
    let currentLine = substitute(currentLine, '\c\<MIN\>'     , 'min'         , 'g')
    let currentLine = substitute(currentLine, '\c\<NOCOUNT\>' , 'nocount'     , 'g')

    "" Ensure equal signs are surrounded by space.
    let currentLine = substitute(currentLine, '\(\S\)=\(\S\)', '\1 = \2', 'g')
    "" Ensure commas are followed by space.
    let currentLine = substitute(currentLine, ',\(\S\)', ', \1', 'g')
    "" Get rid of superfluous identifier brackets, then add them back where
    "" actually necessary.
    ""let currentLine = substitute(currentLine, '\[\|\]', ,'', 'g')
    "" Doesn't work from here. Don't know why.

    call setline(lineNumber, currentLine)
  endfor

  if a:lastline > a:firstline
    echo "DeYelled SQL" (a:lastline - a:firstline + 1) "lines."
  endif
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
