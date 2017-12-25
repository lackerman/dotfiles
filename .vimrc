execute pathogen#infect()

" Based on @mislav post http://mislav.uniqpath.com/2011/12/vim-revisited/
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
"set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" My customizations
set ls=2                        " always show status bar
set number                      " show line numbers
set cursorline                  " display a marker on current line

" Get colours working in Terminal
color Tomorrow-Night-Eighties
set t_Co=256
set background=dark

set completeopt=menuone,longest " simple autocomplete for anything
set wildmode=list:longest,full  " autocomplete for paths and files
set wildignore+=.git            " ignore these extensions on autocomplete
set hidden                      " change buffers without warnings even when there are unsaved changes

" Use for git pane to see changes sooner
set updatetime=200

" Key-combo to autoformat and return the cursor to your current position
let @f='mzgg=G`z'               

" Copy the vim buffer to the clipboard
:verbose map @c :w !pbcopy<CR>

" Toggle the NERDTree panel
:verbose map <C-_> :NERDTreeToggle<CR>
:verbose map <C-b> :GoBuild<CR>
:verbose map <C-i> :GoDef<CR>

" Tab a selection
vmap <Tab> >gv
vmap <S-Tab> <gv

" Configuration for tmux-navigator
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

