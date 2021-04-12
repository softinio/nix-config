set directory=$HOME/.vim/swapfiles/swap//
set undodir=~/.vim/swapfiles/undo//
set backupdir=~/.vim/swapfiles/backup//
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
set t_Co=256
set encoding=utf-8
syntax on
set expandtab
set hidden
set showmatch
set colorcolumn=120
set cursorcolumn
set cursorline
set cmdheight=2
set smarttab
set linebreak
set hlsearch
set ignorecase
set incsearch
set guifont=SF\ Mono:h12
set termguicolors
let g:clipboard = {
      \ 'name': 'pbcopy',
      \ 'copy': {
      \    '+': 'pbcopy',
      \    '*': 'pbcopy',
      \  },
      \ 'paste': {
      \    '+': 'pbpaste',
      \    '*': 'pbpaste',
      \ },
      \ 'cache_enabled': 0,
      \ }
set clipboard=unnamed
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let g:seoul256_background = 233
let g:seoul256_srgb = 1
colorscheme seoul256
set background=dark
set number
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide= '.*\.pyc$'
au BufRead,BufNewFile *.sbt set filetype=scala
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
let g:ackprg='rg --vimgrep --no-heading'
set grepprg=rg\ --vimgrep
let g:rg_command = 'rg --vimgrep -S'
let mapleader = "\<space>"
map! jj <ESC>
" FZF
set rtp+=/Users/salar/.nix-profile/bin/fzf
imap <c-x><c-o> <plug>(fzf-complete-line)
map <leader>b :Buffers<cr>
map <leader>f :Files<cr>
map <leader>g :GFiles<cr>
map <leader>y :Tags<cr>
autocmd! FileType fzf tnoremap <buffer> <leader>q <c-c>
nnoremap <C-p> :FZF<CR>

let g:rainbow_active = 1
let g:rainbow_conf = {
    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
    \   'operators': '_,_',
    \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \   'separately': {
    \       '*': {},
    \       'tex': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \       },
    \       'lisp': {
    \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \       },
    \       'vim': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \       },
    \       'html': {
    \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \       },
    \       'css': 0,
    \   }
    \}
    let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
    \ }

" Nerdtree Configuration
let NERDTreeIgnore=['\.pyc$', '\~$', 'target'] "ignore files in NERDTree
let NERDTreeRespectWildIgnore=1
let NERDTreeQuitOnOpen=1
map <leader>m :NERDTreeToggle<CR>
" jump back to nerdtree
map <leader>n :NERDTree<CR>
" reveal in side bar
map <leader>e :NERDTreeFind<CR>
let NERDTreeShowHidden=1
"nerdtree-git-plugin
let g:NERDTreeGitStatusIndicatorMapCustom= {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" Switch to previous buffer mapped to tab
function SwitchBuffer()
  b#
endfunction

nmap <A-Tab> :call SwitchBuffer()<CR>

" split-term
let g:split_term_default_shell = "fish"
let g:split_term_vertical = 1

" mkdx settings
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                \ 'enter': { 'shift': 1 },
                \ 'links': { 'external': { 'enable': 1 } },
                \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                \ 'fold': { 'enable': 1 } }
let g:polyglot_disabled = ['markdown']


