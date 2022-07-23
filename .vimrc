" Based on @mislav post http://mislav.uniqpath.com/2011/12/vim-revisited/
set nocompatible
set encoding=utf-8
set showcmd " display incomplete commands

call plug#begin()
Plug '/opt/homebrew/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'mhinz/vim-signify'

Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " On-demand loading
Plug 'fatih/vim-go', { 'tag': '*' } " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)

" Style plugins
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'

Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'dense-analysis/ale'

call plug#end()

" Auto-run prettier and eslint autocomplete on save, and rubocop
let g:ale_fix_on_save = 1

let g:ale_fixers = {
\ 'javascript': ['prettier', 'eslint'],
\ 'json': ['prettier'],
\ 'ruby': ['rubocop']
\}

" Because eslint and flow don't play well, we have to specify fixers and linters separately,
" From: https://www.reddit.com/r/vim/comments/94g7nx/help_request_ale_eslint_and_flow_getting_them_to/
let g:ale_linters = {
\ 'javascript': ['prettier', 'flow-language-server', 'eslint'],
\ 'javascriptreact': ['prettier', 'flow-language-server', 'eslint'],
\ 'json': ['prettier'],
\ 'ruby': ['rubocop']
\}

" Specify prettier and rubocop config
let g:ale_javascript_prettier_options = '--no-bracket-spacing --trailing-comma es5'

" Automatically enabled by vim plug
" - syntax enable
" - filetype plugin indent on

"" Whitespace
"set expandtab                  " use spaces, not tabs (optional)
set nowrap                      " don't wrap lines
set tabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
set backspace=indent,eol,start  " backspace through everything in insert mode

" Set syntax and indentations based on filetype, but use 2 space tabs and
" expand tabs to spaces
filetype indent plugin on
set autoindent
set shiftwidth=2
set softtabstop=2
set expandtab
syntax on

" Allow having multiple files open and page through them with :bp and :bn.
" When switching files, preserve cursor location
set hidden
set nostartofline

" Autocomplete : commands and show the last command
set wildmenu
set showcmd

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

"" My customizations
set ls=2                        " always show status bar
set number                      " show line numbers
set cursorline                  " display a marker on current line
set ruler

"" Get colours working in Terminal
color Tomorrow-Night-Eighties
set t_Co=256
set background=dark

" make Y act the same as D (copy to the end of the line)
map Y y$
set completeopt=menuone,longest " simple autocomplete for anything
set wildmode=list:longest,full  " autocomplete for paths and files
set wildignore+=.git            " ignore these extensions on autocomplete
set hidden                      " change buffers without warnings even when there are unsaved changes

" Key-combo to autoformat and return the cursor to your current position
let @f='mzgg=G`z'               

" Copy the vim buffer to the clipboard
:verbose map @c :w !pbcopy<CR>

" Toggle the NERDTree panel
:verbose map <C-/> :NERDTreeToggle<CR>
:verbose map <C-b> :GoBuild<CR>
:verbose map <C-i> :GoDef<CR>
:verbose map <C-x> "+y

:verbose map <C-e> :CtrlPBuffer<CR>
" Open fzf for Ctrl-F
:verbose map <C-f> :Files<CR>

" Tab a selection
vmap <Tab> >gv
vmap <S-Tab> <gv

" Configuration for tmux-navigator
let g:tmux_navigator_no_mappings = 1

" Cntrl+L to clear highlighting/search results
nnoremap <C-n> :nohl<CR><C-L>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

vnoremap y y:call system('pbcopy', @")<CR>

" remove the neovim warning regarding the go plugin
let g:go_version_warning = 0

" default updatetime 4000ms is not good for async update
set updatetime=100
