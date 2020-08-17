set nocompatible              " be iMproved, required
filetype off                  " required

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" File explorer  
Plug 'preservim/nerdtree' 
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git commands
Plug 'tpope/vim-fugitive'
" Git diff lines
Plug 'airblade/vim-gitgutter'
" pretty status bar (including Git)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Support (syntax, indent...) for many languages
Plug 'sheerun/vim-polyglot'

" Code formatting
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'

" fzf fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color themes
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

" auto detect indent
Plug 'ciaranm/detectindent'

" tmux + vim navigation
Plug 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call plug#end()            " required
" the glaive#Install() should go after the "call vundle#end()"
call glaive#Install()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" show line numbers
set number
set relativenumber

" make tabs visible
set list
set listchars=tab:>-

" default indent settings
set expandtab
set shiftwidth=4
set softtabstop=4
" disable text concealing in Markdown 
set conceallevel=0

" Color theme 
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'
colorscheme material
" status bar theme
let g:airline_theme='material'
" dark mode go brrr
set background=dark
" Transparent background
hi Normal guibg=NONE ctermbg=NONE
" highlight current line of cursor
set cursorline

" enable true color
if (has("termguicolors"))
    " fix for tmux
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    set termguicolors
endif

" toggle ibus-bamboo
" WARNING: cause delays when switching modes, makes bracket expanding very slow
function! IBusOff()
  " Lưu engine hiện tại
  let g:ibus_prev_engine = system('ibus engine')
  " Chuyển sang engine tiếng Anh
  execute 'silent !ibus engine xkb:us::eng'
endfunction
function! IBusOn()
  let l:current_engine = system('ibus engine')
  " nếu engine được set trong normal mode thì
  " lúc vào insert mode duùn luôn engine đó
  if l:current_engine !~? 'xkb:us::eng'
    let g:ibus_prev_engine = l:current_engine
  endif
  " Khôi phục lại engine
  execute 'silent !' . 'ibus engine ' . g:ibus_prev_engine
endfunction
if executable("ibus") == 1
    augroup IBusHandler
        " Khôi phục ibus engine khi tìm kiếm
        autocmd CmdLineEnter [/?] silent call IBusOn()
        autocmd CmdLineLeave [/?] silent call IBusOff()
        autocmd CmdLineEnter \? silent call IBusOn()
        autocmd CmdLineLeave \? silent call IBusOff()
        " Khôi phục ibus engine khi vào insert mode
        autocmd InsertEnter * silent call IBusOn()
        " Tắt ibus engine khi vào normal mode
        autocmd InsertLeave * silent call IBusOff()
    augroup END
    silent call IBusOff()
endif

" enable mouse
set mouse=a

" Bracket expanding: auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()

" disable auto comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" tweak command autocompletion behavior (similar to terminal)
set wildmode=longest:full,full

" change the swap directory
set directory=~/.vim/swapfiles/

" remember last position in a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Toggle paste mode
set pastetoggle=<F3>

" Open NERDtree when open
" autocmd vimenter * NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p
" Key to toggle nerdtree
nmap <F4> :NERDTreeToggle<CR>
" Single click to open file / expand dir
let g:NERDTreeMouseMode = 2
" Open in new tab when click on file
autocmd VimEnter * call NERDTreeAddKeyMap({ 'key': '<2-LeftMouse>', 'scope': "FileNode", 'callback': "OpenInTab", 'override':1 })
function! OpenInTab(node)
    call a:node.activate({'reuse': 'all', 'where': 't'})
endfunction 
" Close NERDTree after opening a file
let NERDTreeQuitOnOpen=1
" Show hidden files by default
let NERDTreeShowHidden=1
" show COC status on status line
set statusline^=%{coc#status()}

" ====== coc.nvim config starts ======

let g:coc_global_extensions = ['coc-python', 'coc-tsserver', 'coc-json']
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" disable warning for old vim versions
let g:coc_disable_startup_warning = 1

" ====== coc.nvim config ends ======

" Git Gutter
let g:gitgutter_max_signs = 500 " surpress signs threshold to avoid slowing down UI
" No key mapping
"let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn " remove sign column background color
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange guifg=#3681e3 ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" integrate powerline font into status bar
" 1. Font installation: https://powerline.readthedocs.io/en/master/installation/linux.html#patched-font-installation 
" 2. Link to patched font: https://github.com/powerline/fonts/raw/master/NotoMono/Noto%20Mono%20for%20Powerline.ttf
let g:airline_powerline_fonts = 1
" disable all airline extensions
"let g:airline_extensions = []
" remove delay when switching to normal mode
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

set encoding=utf-8
