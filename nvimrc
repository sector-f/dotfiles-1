set shell=zsh

syntax on
filetype plugin indent on
set nu
set autoindent
set hidden
set wildmenu
set clipboard=unnamedplus
set ignorecase smartcase
set linebreak
"set autochdir

au BufNewFile,BufRead,FileType php set tabstop=4 shiftwidth=4 expandtab
au BufNewFile,BufRead,FileType c set tabstop=4 shiftwidth=4
au BufNewFile,BufRead,FileType cpp set tabstop=4 shiftwidth=4
au BufNewFile,BufRead,FileType asciidoc set nospell

call plug#begin('~/.config/nvim/plugged')
"" Make sure you use single quotes
"" Group dependencies, vim-snippets depends on ultisnips
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'MPiccinato/wombat256'
Plug 'cosarara97/vim-wasabi-colorscheme'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'majutsushi/tagbar'
Plug 'JazzCore/ctrlp-cmatcher'
Plug 'evidens/vim-twig'
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
Plug 'cosarara97/vim-template'
Plug 'rust-lang/rust.vim'
Plug 'AndrewRadev/linediff.vim'
"Plug 'kovisoft/slimv'
"Plug 'JazzCore/ctrlp-cmatcher''
Plug 'rust-lang/rust.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dag/vim-fish'
Plug 'morhetz/gruvbox'
Plug 'ap/vim-css-color'

"Plug 'asciidoc/vim-asciidoc'
"Plug 'mjakl/vim-asciidoc'
"Plug 'powerman/asciidoc', { 'branch': 'powerman', 'rtp': 'vim' }

Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/SyntaxRange'
Plug 'dahu/vimple'
Plug 'dahu/Asif'
Plug 'Raimondi/VimRegStyle'
Plug 'dahu/vim-asciidoc'

Plug 'hynek/vim-python-pep8-indent'

Plug '~/projects/zig/doc/vim'

"" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
"" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'
call plug#end()

let g:gruvbox_italic=1
"colorscheme wombat256
colorscheme wasabi256
"colorscheme gruvbox

"set background=dark

let vimple_init_vars = 0

"let g:vim_asciidoc_folding_disabled=1

let g:airline#extensions#tabline#enabled = 1
"let g:airline_theme='molokai'
let g:airline_theme='base16_default'
let g:airline_powerline_fonts = 1

let g:email = 'jaume@delclos.com'

noremap k n
noremap K N

noremap n h
noremap i j
noremap o k
noremap h l
noremap l o
noremap ; i

noremap <C-W>n <C-W>h
noremap <C-W>i <C-W>j
noremap <C-W>o <C-W>k
noremap <C-W>h <C-W>l

"tnoremap <Esc> <C-\><C-n>

let mapleader = "\<Space>"
nnoremap <CR> :noh<CR><CR>
nnoremap <leader>p :CtrlPTag<CR>
nnoremap <silent> <Leader>t :TagbarToggle<CR>
"nnoremap <Leader>b :b
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>N :bp<CR>

nnoremap <c-f> :Files<cr>
nnoremap <Leader>f :Files<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap <Leader>b :Buffers<cr>

set laststatus=2

command! Bbspaces %s/\s\+$

" breaks tag search
"let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
"      \ --ignore .git
"      \ --ignore .svn
"      \ --ignore .hg
"      \ --ignore .DS_Store
"      \ --ignore "**/*.pyc"
"      \ -g ""'

" neither seems faster
"let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
"let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

call unite#filters#matcher_default#use(['matcher_fuzzy'])

"nnoremap <leader>e :Unite -quick-match buffer<cr>
nnoremap <leader>e :Unite -start-insert buffer<cr>
nnoremap <leader>f :Unite -start-insert file<cr>
nnoremap <space>/ :Unite grep:. -auto-preview -auto-highlight -no-split<cr>

nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" kinda like autochdir?
"autocmd BufEnter * silent! lcd %:p:h
"let g:slimv_swank_cmd ='! xterm -e sbcl --load ~/utils/start-swank.lisp &' "


let g:terminal_color_0="#353540"
let g:terminal_color_1="#8c5760"
let g:terminal_color_2="#7b8c58"
let g:terminal_color_3="#8c6e43"
let g:terminal_color_4="#58698c"
let g:terminal_color_5="#7b5e7d"
let g:terminal_color_6="#66808c"
let g:terminal_color_7="#8c8b8b"
let g:terminal_color_8="#545466"
let g:terminal_color_9="#b26f7a"
let g:terminal_color_10="#9db270"
let g:terminal_color_11="#b28c55"
let g:terminal_color_12="#7086b2"
let g:terminal_color_13="#9c77b2"
let g:terminal_color_14="#82a2b2"
let g:terminal_color_15="#b8b8c8"
let g:terminal_color_background="#09090d"
let g:terminal_color_foreground="#839496"
"
"let g:terminal_color_0="#1b2b34"
"let g:terminal_color_1="#ed5f67"
"let g:terminal_color_2="#9ac895"
"let g:terminal_color_3="#fbc963"
"let g:terminal_color_4="#669acd"
"let g:terminal_color_5="#c695c6"
"let g:terminal_color_6="#5fb4b4"
"let g:terminal_color_7="#c1c6cf"
"let g:terminal_color_8="#65737e"
"let g:terminal_color_9="#fa9257"
"let g:terminal_color_10="#343d46"
"let g:terminal_color_11="#4f5b66"
"let g:terminal_color_12="#a8aebb"
"let g:terminal_color_13="#ced4df"
"let g:terminal_color_14="#ac7967"
"let g:terminal_color_15="#d9dfea"
"let g:terminal_color_background="#1b2b34"
"let g:terminal_color_foreground="#c1c6cf"
